# Desain Penyelesaian Tugas Basis Data NON-IUP

## Tujuan

Menyelesaikan seluruh Tugas Kelompok I “Model Data Relasional dan Querynya” menggunakan template LaTeX NON-IUP. Hasil akhir berupa PDF terkompilasi dan project LaTeX lengkap yang siap dikemas sebagai ZIP.

## Identitas sementara

Identitas berikut digunakan sampai data anggota sebenarnya tersedia:

1. Anggota 1 — 00/000001/PA/00001
2. Anggota 2 — 00/000002/PA/00002
3. Anggota 3 — 00/000003/PA/00003
4. Anggota 4 — 00/000004/PA/00004

Identitas sampul menggunakan “Kelompok Basis Data” dan keterangan empat anggota ditulis lengkap pada Bab Hasil dan Pembahasan.

## Pembagian kontribusi

### Anggota 1 — Analisis dan ERD

- Menganalisis proses bisnis akademik.
- Mengidentifikasi entitas, atribut, kunci, relasi, kardinalitas, dan partisipasi.
- Menjelaskan penyimpanan histori, pengulangan mata kuliah, kelas paralel, dan prasyarat.
- Membuat ERD final.

### Anggota 2 — Skema relasional dan DDL

- Memetakan ERD menjadi skema relasional.
- Memeriksa normalisasi hingga 3NF.
- Menentukan primary key, foreign key, unique key, dan check constraint.
- Menulis dan menguji DDL MySQL.

### Anggota 3 — Query 1–3

- Menentukan tabel dan kriteria join.
- Menulis SQL utama dan alternatif.
- Menulis ekspresi aljabar relasional.
- Menguji query terhadap data uji.

### Anggota 4 — Query 4–5 dan integrasi

- Menulis query IPS dan IPK dengan aturan nilai pengambilan terakhir.
- Menulis SQL alternatif dan aljabar relasional.
- Mengintegrasikan seluruh hasil ke `jawaban.tex`.
- Memperbaiki kompilasi, memeriksa PDF, dan menyiapkan ZIP.

## Model data

Model menggunakan tabel inti berikut:

- `program_studi`
- `mahasiswa`
- `dosen`
- `mata_kuliah`
- `prasyarat_mata_kuliah`
- `semester_akademik`
- `kelas_kuliah`
- `pengambilan_kuliah`

`prasyarat_mata_kuliah` merepresentasikan relasi rekursif banyak-ke-banyak antarmata kuliah. `kelas_kuliah` merepresentasikan penawaran mata kuliah pada semester tertentu dan diajar oleh tepat satu dosen. `pengambilan_kuliah` menyimpan setiap riwayat pengambilan sebagai baris tersendiri sehingga pengulangan tidak menghapus histori.

## Aturan nilai

- Bobot: A=4.00, A-=3.75, A/B=3.50, B+=3.25, B=3.00, B-=2.75, B/C=2.50, C+=2.25, C=2.00, C/D=1.50, D=1.00, E=0.00.
- IPS menghitung seluruh mata kuliah pada satu semester tertentu.
- IPK menghitung satu pengambilan terakhir untuk setiap pasangan mahasiswa dan mata kuliah.
- “Tiga tahun terakhir” ditentukan relatif terhadap tanggal berjalan menggunakan tahun mulai semester akademik.

## Lima query

1. Mata kuliah pilihan beserta prasyarat; mata kuliah tanpa prasyarat tetap tampil menggunakan `LEFT JOIN`.
2. Mata kuliah pilihan yang diambil mahasiswa Ilmu Komputer angkatan 2024 pada semester ganjil 2026/2027.
3. Tiga mata kuliah pilihan dengan pengambil terbanyak dalam tiga tahun terakhir; hasil seri ditangani menggunakan `DENSE_RANK()`.
4. Mahasiswa dengan IPS semester ganjil 2025/2026 minimal 3,25.
5. Mahasiswa dan IPK terkini dengan hanya pengambilan terakhir setiap mata kuliah, menggunakan `ROW_NUMBER()`.

Setiap query memuat tabel yang terlibat, jenis dan kondisi join, SQL utama, SQL alternatif, penjelasan, serta aljabar relasional.

## Berkas yang diubah atau dibuat

- Ubah `TemplateTugas.tex`: identitas dummy dan penyesuaian kompilasi.
- Ubah `jawaban.tex`: seluruh jawaban tugas.
- Ubah `tugasMIPA.cls` hanya bila diperlukan untuk kompatibilitas TeX Live.
- Buat `erd-akademik.png`: ERD final.
- Buat `schema.sql`: DDL dan data uji.
- Buat `queries.sql`: lima query dan alternatifnya.
- Buat `README.md`: petunjuk kompilasi dan penggantian identitas.
- Hasilkan `TemplateTugas.pdf`.
- Hasilkan arsip project ZIP.

## Verifikasi

- Jalankan DDL pada MySQL.
- Masukkan data uji yang mencakup prasyarat kosong, mata kuliah pilihan, kelas paralel, pengulangan, dan nilai lintas semester.
- Jalankan semua query utama dan alternatif.
- Bandingkan hasil query alternatif dengan hasil query utama.
- Kompilasi LaTeX hingga seluruh referensi stabil.
- Periksa log untuk error dan placeholder tersisa.
- Periksa PDF secara visual.
- Ekstrak ZIP ke direktori bersih lalu kompilasi ulang.

## Batasan

- Seluruh isi substantif tetap ditempatkan di `jawaban.tex`.
- Struktur minimal template tidak dikurangi.
- Bahasa laporan formal dan mudah dipahami.
- Identitas dummy wajib diganti sebelum pengumpulan.
- Setiap anggota tetap harus menguasai seluruh hasil kelompok dan mengunggah tugas secara individu.
