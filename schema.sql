DROP DATABASE IF EXISTS tugas_akademik;
CREATE DATABASE tugas_akademik CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE tugas_akademik;

CREATE TABLE program_studi (
    kode_prodi VARCHAR(10) PRIMARY KEY,
    nama_prodi VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE mahasiswa (
    nim VARCHAR(20) PRIMARY KEY,
    nama_mahasiswa VARCHAR(100) NOT NULL,
    tahun_masuk YEAR NOT NULL,
    kode_prodi VARCHAR(10) NOT NULL,
    CONSTRAINT fk_mahasiswa_prodi FOREIGN KEY (kode_prodi)
        REFERENCES program_studi(kode_prodi)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE dosen (
    nidn VARCHAR(20) PRIMARY KEY,
    nama_dosen VARCHAR(100) NOT NULL
);

CREATE TABLE mata_kuliah (
    kode_mk VARCHAR(10) PRIMARY KEY,
    nama_mk VARCHAR(100) NOT NULL,
    sks TINYINT UNSIGNED NOT NULL,
    sifat ENUM('W', 'P') NOT NULL,
    kode_prodi VARCHAR(10) NOT NULL,
    CONSTRAINT chk_mk_sks CHECK (sks BETWEEN 1 AND 6),
    CONSTRAINT fk_mk_prodi FOREIGN KEY (kode_prodi)
        REFERENCES program_studi(kode_prodi)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE prasyarat_mata_kuliah (
    kode_mk VARCHAR(10) NOT NULL,
    kode_mk_prasyarat VARCHAR(10) NOT NULL,
    PRIMARY KEY (kode_mk, kode_mk_prasyarat),
    CONSTRAINT chk_prasyarat_bukan_diri CHECK (kode_mk <> kode_mk_prasyarat),
    CONSTRAINT fk_prasyarat_mk FOREIGN KEY (kode_mk)
        REFERENCES mata_kuliah(kode_mk)
        ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT fk_prasyarat_induk FOREIGN KEY (kode_mk_prasyarat)
        REFERENCES mata_kuliah(kode_mk)
        ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE semester_akademik (
    id_semester INT AUTO_INCREMENT PRIMARY KEY,
    tahun_mulai YEAR NOT NULL,
    tahun_selesai YEAR NOT NULL,
    jenis ENUM('Ganjil', 'Genap') NOT NULL,
    tanggal_mulai DATE NOT NULL,
    tanggal_selesai DATE NOT NULL,
    CONSTRAINT uq_semester UNIQUE (tahun_mulai, tahun_selesai, jenis),
    CONSTRAINT chk_tahun_akademik CHECK (tahun_selesai = tahun_mulai + 1),
    CONSTRAINT chk_tanggal_semester CHECK (tanggal_selesai > tanggal_mulai)
);

CREATE TABLE kelas_kuliah (
    id_kelas BIGINT AUTO_INCREMENT PRIMARY KEY,
    kode_mk VARCHAR(10) NOT NULL,
    id_semester INT NOT NULL,
    kode_kelas VARCHAR(10) NOT NULL,
    nidn VARCHAR(20) NOT NULL,
    kapasitas SMALLINT UNSIGNED NOT NULL DEFAULT 40,
    CONSTRAINT uq_kelas UNIQUE (kode_mk, id_semester, kode_kelas),
    CONSTRAINT chk_kapasitas CHECK (kapasitas > 0),
    CONSTRAINT fk_kelas_mk FOREIGN KEY (kode_mk)
        REFERENCES mata_kuliah(kode_mk)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_kelas_semester FOREIGN KEY (id_semester)
        REFERENCES semester_akademik(id_semester)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_kelas_dosen FOREIGN KEY (nidn)
        REFERENCES dosen(nidn)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE pengambilan_kuliah (
    id_pengambilan BIGINT AUTO_INCREMENT PRIMARY KEY,
    nim VARCHAR(20) NOT NULL,
    id_kelas BIGINT NOT NULL,
    nilai_huruf ENUM('A', 'A-', 'A/B', 'B+', 'B', 'B-', 'B/C', 'C+', 'C', 'C/D', 'D', 'E') NULL,
    bobot DECIMAL(3,2) NULL,
    tanggal_input_nilai DATE NULL,
    CONSTRAINT uq_pengambilan UNIQUE (nim, id_kelas),
    CONSTRAINT chk_nilai_bobot CHECK (
        (nilai_huruf IS NULL AND bobot IS NULL) OR
        (nilai_huruf = 'A'   AND bobot = 4.00) OR
        (nilai_huruf = 'A-'  AND bobot = 3.75) OR
        (nilai_huruf = 'A/B' AND bobot = 3.50) OR
        (nilai_huruf = 'B+'  AND bobot = 3.25) OR
        (nilai_huruf = 'B'   AND bobot = 3.00) OR
        (nilai_huruf = 'B-'  AND bobot = 2.75) OR
        (nilai_huruf = 'B/C' AND bobot = 2.50) OR
        (nilai_huruf = 'C+'  AND bobot = 2.25) OR
        (nilai_huruf = 'C'   AND bobot = 2.00) OR
        (nilai_huruf = 'C/D' AND bobot = 1.50) OR
        (nilai_huruf = 'D'   AND bobot = 1.00) OR
        (nilai_huruf = 'E'   AND bobot = 0.00)
    ),
    CONSTRAINT fk_pengambilan_mahasiswa FOREIGN KEY (nim)
        REFERENCES mahasiswa(nim)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_pengambilan_kelas FOREIGN KEY (id_kelas)
        REFERENCES kelas_kuliah(id_kelas)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

INSERT INTO program_studi VALUES
('IK', 'Ilmu Komputer'),
('EL', 'Elektronika dan Instrumentasi');

INSERT INTO mahasiswa VALUES
('24IK001', 'Aditya Pratama', 2024, 'IK'),
('24IK002', 'Bella Maharani', 2024, 'IK'),
('23IK001', 'Citra Lestari', 2023, 'IK'),
('22IK001', 'Damar Nugraha', 2022, 'IK'),
('24EL001', 'Eka Saputra', 2024, 'EL');

INSERT INTO dosen VALUES
('D001', 'Dr. Andi Wijaya'),
('D002', 'Dr. Bunga Kartika'),
('D003', 'Dr. Candra Kusuma');

INSERT INTO mata_kuliah VALUES
('IK101', 'Dasar Pemrograman', 3, 'W', 'IK'),
('IK201', 'Basis Data', 3, 'W', 'IK'),
('IK301', 'Kecerdasan Buatan', 3, 'P', 'IK'),
('IK302', 'Data Mining', 3, 'P', 'IK'),
('IK303', 'Komputasi Awan', 3, 'P', 'IK'),
('IK304', 'Interaksi Manusia dan Komputer', 3, 'P', 'IK'),
('EL101', 'Rangkaian Elektronika', 3, 'W', 'EL');

INSERT INTO prasyarat_mata_kuliah VALUES
('IK301', 'IK101'),
('IK302', 'IK201'),
('IK303', 'IK201');

INSERT INTO semester_akademik
(id_semester, tahun_mulai, tahun_selesai, jenis, tanggal_mulai, tanggal_selesai) VALUES
(1, 2023, 2024, 'Ganjil', '2023-08-01', '2023-12-31'),
(2, 2024, 2025, 'Ganjil', '2024-08-01', '2024-12-31'),
(3, 2025, 2026, 'Ganjil', '2025-08-01', '2025-12-31'),
(4, 2025, 2026, 'Genap',  '2026-02-01', '2026-06-30'),
(5, 2026, 2027, 'Ganjil', '2026-08-01', '2026-12-31');

INSERT INTO kelas_kuliah
(id_kelas, kode_mk, id_semester, kode_kelas, nidn, kapasitas) VALUES
(1,  'IK101', 1, 'A', 'D001', 40),
(2,  'IK201', 2, 'A', 'D002', 40),
(3,  'IK301', 2, 'A', 'D003', 40),
(4,  'IK302', 3, 'A', 'D002', 40),
(5,  'IK303', 3, 'A', 'D001', 40),
(6,  'IK304', 3, 'A', 'D003', 40),
(7,  'IK201', 3, 'A', 'D002', 40),
(8,  'IK301', 5, 'A', 'D003', 40),
(9,  'IK301', 5, 'B', 'D001', 40),
(10, 'IK302', 5, 'A', 'D002', 40),
(11, 'IK304', 5, 'A', 'D003', 40),
(12, 'EL101', 5, 'A', 'D001', 40),
(13, 'IK302', 4, 'A', 'D002', 40);

INSERT INTO pengambilan_kuliah
(nim, id_kelas, nilai_huruf, bobot, tanggal_input_nilai) VALUES
('22IK001', 1,  'B',   3.00, '2024-01-05'),
('22IK001', 3,  'A-',  3.75, '2025-01-05'),
('23IK001', 2,  'B+',  3.25, '2025-01-05'),
('23IK001', 3,  'B',   3.00, '2025-01-05'),
('23IK001', 4,  'A',   4.00, '2026-01-05'),
('23IK001', 5,  'B+',  3.25, '2026-01-05'),
('24IK001', 2,  'C',   2.00, '2025-01-05'),
('24IK001', 7,  'A',   4.00, '2026-01-05'),
('24IK001', 4,  'A-',  3.75, '2026-01-05'),
('24IK001', 5,  'B+',  3.25, '2026-01-05'),
('24IK001', 6,  'A',   4.00, '2026-01-05'),
('24IK002', 7,  'B+',  3.25, '2026-01-05'),
('24IK002', 4,  'B',   3.00, '2026-01-05'),
('24IK002', 6,  'A-',  3.75, '2026-01-05'),
('24IK001', 8,  NULL,  NULL, NULL),
('24IK001', 10, NULL,  NULL, NULL),
('24IK002', 9,  NULL,  NULL, NULL),
('24IK002', 11, NULL,  NULL, NULL),
('24EL001', 12, NULL,  NULL, NULL),
('22IK001', 13, 'A',   4.00, '2026-07-05');
