USE tugas_akademik;

-- Q1: mata kuliah pilihan beserta mata kuliah prasyaratnya.
SELECT mk.kode_mk, mk.nama_mk,
       pre.kode_mk AS kode_prasyarat,
       pre.nama_mk AS nama_prasyarat
FROM mata_kuliah AS mk
LEFT JOIN prasyarat_mata_kuliah AS pmk ON pmk.kode_mk = mk.kode_mk
LEFT JOIN mata_kuliah AS pre ON pre.kode_mk = pmk.kode_mk_prasyarat
WHERE mk.sifat = 'P'
ORDER BY mk.kode_mk, pre.kode_mk;

-- Q1 alternatif: correlated scalar subquery (sesuai data uji: maksimal satu prasyarat per MK).
SELECT mk.kode_mk, mk.nama_mk,
       (SELECT pmk.kode_mk_prasyarat
        FROM prasyarat_mata_kuliah AS pmk
        WHERE pmk.kode_mk = mk.kode_mk
        LIMIT 1) AS kode_prasyarat,
       (SELECT pre.nama_mk
        FROM prasyarat_mata_kuliah AS pmk
        JOIN mata_kuliah AS pre ON pre.kode_mk = pmk.kode_mk_prasyarat
        WHERE pmk.kode_mk = mk.kode_mk
        LIMIT 1) AS nama_prasyarat
FROM mata_kuliah AS mk
WHERE mk.sifat = 'P'
ORDER BY mk.kode_mk;

-- Q2: MK pilihan yang diambil mahasiswa IK angkatan 2024, Ganjil 2026/2027.
SELECT DISTINCT mk.kode_mk, mk.nama_mk
FROM pengambilan_kuliah AS pk
JOIN mahasiswa AS m ON m.nim = pk.nim
JOIN program_studi AS ps ON ps.kode_prodi = m.kode_prodi
JOIN kelas_kuliah AS kk ON kk.id_kelas = pk.id_kelas
JOIN mata_kuliah AS mk ON mk.kode_mk = kk.kode_mk
JOIN semester_akademik AS sa ON sa.id_semester = kk.id_semester
WHERE ps.nama_prodi = 'Ilmu Komputer'
  AND m.tahun_masuk = 2024
  AND mk.sifat = 'P'
  AND sa.jenis = 'Ganjil'
  AND sa.tahun_mulai = 2026
  AND sa.tahun_selesai = 2027
ORDER BY mk.kode_mk;

-- Q2 alternatif dengan EXISTS.
SELECT mk.kode_mk, mk.nama_mk
FROM mata_kuliah AS mk
WHERE mk.sifat = 'P'
  AND EXISTS (
      SELECT 1
      FROM pengambilan_kuliah AS pk
      JOIN mahasiswa AS m ON m.nim = pk.nim
      JOIN program_studi AS ps ON ps.kode_prodi = m.kode_prodi
      JOIN kelas_kuliah AS kk ON kk.id_kelas = pk.id_kelas
      JOIN semester_akademik AS sa ON sa.id_semester = kk.id_semester
      WHERE kk.kode_mk = mk.kode_mk
        AND ps.nama_prodi = 'Ilmu Komputer'
        AND m.tahun_masuk = 2024
        AND sa.jenis = 'Ganjil'
        AND sa.tahun_mulai = 2026
        AND sa.tahun_selesai = 2027
  )
ORDER BY mk.kode_mk;

-- Q3: peringkat tiga teratas; seri pada posisi ketiga tetap ditampilkan.
WITH jumlah_pengambil AS (
    SELECT mk.kode_mk, mk.nama_mk,
           COUNT(DISTINCT pk.nim) AS jumlah_mahasiswa
    FROM mata_kuliah AS mk
    JOIN kelas_kuliah AS kk ON kk.kode_mk = mk.kode_mk
    JOIN semester_akademik AS sa ON sa.id_semester = kk.id_semester
    JOIN pengambilan_kuliah AS pk ON pk.id_kelas = kk.id_kelas
    JOIN mahasiswa AS m ON m.nim = pk.nim
    JOIN program_studi AS ps ON ps.kode_prodi = m.kode_prodi
    WHERE mk.sifat = 'P'
      AND ps.nama_prodi = 'Ilmu Komputer'
      AND sa.tahun_mulai BETWEEN 2024 AND 2026
    GROUP BY mk.kode_mk, mk.nama_mk
), peringkat AS (
    SELECT jumlah_pengambil.*,
           DENSE_RANK() OVER (ORDER BY jumlah_mahasiswa DESC) AS peringkat
    FROM jumlah_pengambil
)
SELECT kode_mk, nama_mk, jumlah_mahasiswa, peringkat
FROM peringkat
WHERE peringkat <= 3
ORDER BY peringkat, kode_mk;

-- Q3 alternatif: tepat tiga baris tanpa mempertahankan seri.
SELECT mk.kode_mk, mk.nama_mk,
       COUNT(DISTINCT pk.nim) AS jumlah_mahasiswa
FROM mata_kuliah AS mk
JOIN kelas_kuliah AS kk ON kk.kode_mk = mk.kode_mk
JOIN semester_akademik AS sa ON sa.id_semester = kk.id_semester
JOIN pengambilan_kuliah AS pk ON pk.id_kelas = kk.id_kelas
JOIN mahasiswa AS m ON m.nim = pk.nim
JOIN program_studi AS ps ON ps.kode_prodi = m.kode_prodi
WHERE mk.sifat = 'P'
  AND ps.nama_prodi = 'Ilmu Komputer'
  AND sa.tahun_mulai BETWEEN 2024 AND 2026
GROUP BY mk.kode_mk, mk.nama_mk
ORDER BY jumlah_mahasiswa DESC, mk.kode_mk
LIMIT 3;

-- Q4: IPS Ganjil 2025/2026 minimal 3,25.
SELECT m.nim, m.nama_mahasiswa,
       ROUND(SUM(mk.sks * pk.bobot) / SUM(mk.sks), 2) AS ips
FROM mahasiswa AS m
JOIN pengambilan_kuliah AS pk ON pk.nim = m.nim
JOIN kelas_kuliah AS kk ON kk.id_kelas = pk.id_kelas
JOIN mata_kuliah AS mk ON mk.kode_mk = kk.kode_mk
JOIN semester_akademik AS sa ON sa.id_semester = kk.id_semester
WHERE sa.jenis = 'Ganjil'
  AND sa.tahun_mulai = 2025
  AND sa.tahun_selesai = 2026
  AND pk.bobot IS NOT NULL
GROUP BY m.nim, m.nama_mahasiswa
HAVING SUM(mk.sks * pk.bobot) / SUM(mk.sks) >= 3.25
ORDER BY m.nim;

-- Q4 alternatif: agregasi dalam CTE lalu filter dengan WHERE.
WITH nilai_ips AS (
    SELECT m.nim, m.nama_mahasiswa,
           SUM(mk.sks * pk.bobot) / SUM(mk.sks) AS ips
    FROM mahasiswa AS m
    JOIN pengambilan_kuliah AS pk ON pk.nim = m.nim
    JOIN kelas_kuliah AS kk ON kk.id_kelas = pk.id_kelas
    JOIN mata_kuliah AS mk ON mk.kode_mk = kk.kode_mk
    JOIN semester_akademik AS sa ON sa.id_semester = kk.id_semester
    WHERE sa.jenis = 'Ganjil' AND sa.tahun_mulai = 2025
      AND sa.tahun_selesai = 2026 AND pk.bobot IS NOT NULL
    GROUP BY m.nim, m.nama_mahasiswa
)
SELECT nim, nama_mahasiswa, ROUND(ips, 2) AS ips
FROM nilai_ips
WHERE ips >= 3.25
ORDER BY nim;

-- Q5: IPK terkini memakai pengambilan terakhir setiap mata kuliah.
WITH riwayat AS (
    SELECT pk.nim, kk.kode_mk, mk.sks, pk.bobot,
           ROW_NUMBER() OVER (
               PARTITION BY pk.nim, kk.kode_mk
               ORDER BY sa.tanggal_mulai DESC, pk.id_pengambilan DESC
           ) AS urutan
    FROM pengambilan_kuliah AS pk
    JOIN kelas_kuliah AS kk ON kk.id_kelas = pk.id_kelas
    JOIN mata_kuliah AS mk ON mk.kode_mk = kk.kode_mk
    JOIN semester_akademik AS sa ON sa.id_semester = kk.id_semester
    WHERE pk.bobot IS NOT NULL
)
SELECT m.nim, m.nama_mahasiswa,
       ROUND(SUM(r.sks * r.bobot) / SUM(r.sks), 2) AS ipk
FROM mahasiswa AS m
JOIN riwayat AS r ON r.nim = m.nim AND r.urutan = 1
GROUP BY m.nim, m.nama_mahasiswa
ORDER BY m.nim;

-- Q5 alternatif: pilih baris yang tidak mempunyai pengambilan lebih baru.
SELECT m.nim, m.nama_mahasiswa,
       ROUND(SUM(mk.sks * pk.bobot) / SUM(mk.sks), 2) AS ipk
FROM mahasiswa AS m
JOIN pengambilan_kuliah AS pk ON pk.nim = m.nim
JOIN kelas_kuliah AS kk ON kk.id_kelas = pk.id_kelas
JOIN mata_kuliah AS mk ON mk.kode_mk = kk.kode_mk
JOIN semester_akademik AS sa ON sa.id_semester = kk.id_semester
WHERE pk.bobot IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM pengambilan_kuliah AS pk2
      JOIN kelas_kuliah AS kk2 ON kk2.id_kelas = pk2.id_kelas
      JOIN semester_akademik AS sa2 ON sa2.id_semester = kk2.id_semester
      WHERE pk2.nim = pk.nim
        AND kk2.kode_mk = kk.kode_mk
        AND pk2.bobot IS NOT NULL
        AND (sa2.tanggal_mulai > sa.tanggal_mulai OR
             (sa2.tanggal_mulai = sa.tanggal_mulai AND
              pk2.id_pengambilan > pk.id_pengambilan))
  )
GROUP BY m.nim, m.nama_mahasiswa
ORDER BY m.nim;
