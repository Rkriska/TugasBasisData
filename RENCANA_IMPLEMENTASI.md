# Penyelesaian Tugas Basis Data NON-IUP Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Menghasilkan laporan lengkap tentang ERD akademik, skema relasional, DDL, lima query SQL, dan aljabar relasional dalam PDF serta project LaTeX siap ZIP.

**Architecture:** `schema.sql` menjadi definisi formal model dan data uji; `queries.sql` menjadi implementasi serta verifikasi pertanyaan bisnis. `jawaban.tex` menyajikan model yang sama dalam narasi akademik, diagram, notasi relasional, SQL, dan aljabar relasional. `TemplateTugas.tex` tetap menjadi entry point kompilasi.

**Tech Stack:** MySQL 26.7-compatible SQL, LaTeX/pdfLaTeX, Graphviz atau renderer diagram lokal, BibTeX hanya jika referensi dipakai.

**Spec:** `DESAIN_PENGERJAAN.md`

## Global Constraints

- Seluruh jawaban substantif ditempatkan dalam `jawaban.tex`.
- Struktur minimal template tidak dikurangi.
- Identitas menggunakan empat data dummy yang jelas ditandai untuk diganti.
- Nilai transkrip/IPK menggunakan pengambilan terakhir, bukan nilai tertinggi.
- Setiap query memuat tabel, join, SQL utama, SQL alternatif, penjelasan, dan aljabar relasional.
- SQL harus diuji pada MySQL sebelum dicantumkan sebagai hasil final.
- Bahasa laporan formal, lengkap, dan mudah dipahami.

---

### Task 1: Skema dan data uji

**Files:**
- Create: `schema.sql`
- Test: MySQL database `tugas_akademik`

**Interfaces:**
- Produces: tabel `program_studi`, `mahasiswa`, `dosen`, `mata_kuliah`, `prasyarat_mata_kuliah`, `semester_akademik`, `kelas_kuliah`, dan `pengambilan_kuliah`.

- [ ] Tulis pemeriksaan awal yang memastikan database belum memiliki delapan tabel target.
- [ ] Jalankan pemeriksaan dan konfirmasi tabel belum tersedia.
- [ ] Tulis DDL lengkap beserta PK, FK, unique key, dan check constraint.
- [ ] Tambahkan data uji yang mencakup seluruh skenario lima query.
- [ ] Jalankan `mysql -uroot < schema.sql` dan pastikan tidak ada error.
- [ ] Jalankan `SHOW TABLES` dan `SHOW CREATE TABLE` untuk seluruh tabel.

### Task 2: Lima query dan alternatif

**Files:**
- Create: `queries.sql`
- Test: MySQL database `tugas_akademik`

**Interfaces:**
- Consumes: tabel dari `schema.sql`.
- Produces: pasangan query utama/alternatif Q1–Q5 dengan hasil yang ekuivalen.

- [ ] Tulis expected result untuk setiap query berdasarkan data uji.
- [ ] Jalankan expected-result check sebelum query dibuat dan konfirmasi belum tersedia.
- [ ] Implementasikan Q1 dengan `LEFT JOIN` dan alternatif correlated subquery.
- [ ] Implementasikan Q2 dengan explicit joins dan alternatif `EXISTS`.
- [ ] Implementasikan Q3 dengan `DENSE_RANK()` dan alternatif `ORDER BY ... LIMIT 3`.
- [ ] Implementasikan Q4 dengan agregasi IPS dan alternatif CTE.
- [ ] Implementasikan Q5 dengan `ROW_NUMBER()` dan alternatif anti-join `NOT EXISTS`.
- [ ] Jalankan seluruh query.
- [ ] Bandingkan hasil utama dan alternatif untuk memastikan ekuivalensi yang dimaksud.

### Task 3: ERD

**Files:**
- Create: `erd-akademik.dot`
- Create: `erd-akademik.png`

**Interfaces:**
- Consumes: delapan tabel dan constraint dari `schema.sql`.
- Produces: gambar ERD yang dirujuk `jawaban.tex`.

- [ ] Daftar seluruh tabel, PK, FK, dan kardinalitas dari DDL.
- [ ] Tulis diagram Graphviz dengan entitas dan relasi yang sama persis.
- [ ] Render diagram ke PNG resolusi tinggi.
- [ ] Periksa nama atribut, arah relasi, dan keterbacaan gambar.

### Task 4: Isi laporan

**Files:**
- Modify: `jawaban.tex`

**Interfaces:**
- Consumes: `schema.sql`, `queries.sql`, `erd-akademik.png`.
- Produces: Bab Hasil dan Pembahasan lengkap.

- [ ] Ganti daftar anggota dengan empat identitas dummy.
- [ ] Tulis analisis proses bisnis, entitas, relasi, kardinalitas, histori, dan asumsi bobot nilai.
- [ ] Sisipkan `erd-akademik.png` dan caption yang tepat.
- [ ] Tulis skema relasional seluruh tabel.
- [ ] Tulis DDL lengkap dalam listing SQL.
- [ ] Lengkapi Q1–Q5 dengan tabel, join, SQL utama, alternatif, penjelasan, dan aljabar relasional.
- [ ] Hapus seluruh placeholder jawaban.

### Task 5: Sampul dan kompatibilitas LaTeX

**Files:**
- Modify: `TemplateTugas.tex`
- Modify: `tugasMIPA.cls` bila diperlukan

**Interfaces:**
- Consumes: `jawaban.tex` dan aset gambar.
- Produces: entry point LaTeX yang dapat dikompilasi.

- [ ] Ganti identitas contoh pada sampul dengan identitas kelompok dummy.
- [ ] Perbaiki deklarasi bahasa Indonesia agar kompatibel dengan instalasi TeX.
- [ ] Samakan nama class yang disediakan dengan nama file class.
- [ ] Nonaktifkan bibliography jika tidak ada sitasi, atau gunakan style yang valid jika ada sitasi.
- [ ] Jalankan pdfLaTeX dan perbaiki setiap error kompilasi.
- [ ] Jalankan pdfLaTeX ulang hingga cross-reference stabil.

### Task 6: Audit dan kemasan akhir

**Files:**
- Create: `README.md`
- Create: `TugasDatabase_NON-IUP_Dummy.zip`
- Generate: `TemplateTugas.pdf`

**Interfaces:**
- Consumes: seluruh project final.
- Produces: PDF dan ZIP siap ditinjau.

- [ ] Cari placeholder dan identitas contoh dengan `grep`.
- [ ] Periksa log LaTeX untuk error dan undefined references.
- [ ] Konversi halaman PDF menjadi preview dan periksa keterbacaan ERD, SQL, rumus, serta page break.
- [ ] Tulis README berisi cara mengganti identitas, menjalankan SQL, dan mengompilasi LaTeX.
- [ ] Buat ZIP tanpa file build sementara.
- [ ] Ekstrak ZIP ke direktori bersih.
- [ ] Jalankan kembali MySQL dan kompilasi LaTeX dari hasil ekstraksi.
- [ ] Catat file final dan sisa kewajiban manual berupa penggantian identitas dummy.
