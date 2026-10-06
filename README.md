# TugasBasisData

Project LaTeX NON-IUP untuk Tugas Kelompok I Basis Data: **Model Data Relasional dan Querynya**.

## Status identitas

Dokumen masih memakai empat identitas dummy. Sebelum pengumpulan, ganti:

- `\fullname` dan `\idnum` di `TemplateTugas.tex`;
- daftar anggota di awal `jawaban.tex`.

## Isi project

- `TemplateTugas.tex` — entry point dokumen.
- `petunjuktugas.tex` — petunjuk resmi tugas.
- `jawaban.tex` — seluruh jawaban.
- `schema.sql` — DDL, constraint, dan data uji.
- `queries.sql` — lima query utama dan alternatif.
- `erd-akademik.png` — ERD yang disisipkan ke laporan.
- `erd-akademik.dot` — sumber terstruktur ERD.
- `query-results.txt` — hasil eksekusi query pada data uji.
- `TemplateTugas.pdf` — hasil kompilasi laporan.

## Menjalankan SQL

```bash
mysql --protocol=socket -uroot < schema.sql
mysql --protocol=socket -uroot --table < queries.sql
```

Sesuaikan user, password, host, atau socket dengan konfigurasi MySQL lokal.

## Mengompilasi LaTeX

```bash
pdflatex -interaction=nonstopmode -halt-on-error TemplateTugas.tex
pdflatex -interaction=nonstopmode -halt-on-error TemplateTugas.tex
```

Template telah disesuaikan agar dapat dikompilasi pada TeX Live Basic 2026 tanpa `tcolorbox`, `nomencl`, `algorithm`, atau paket bahasa Indonesia terpisah.

## Catatan akademik

- Nilai mata kuliah yang diulang menggunakan **pengambilan terakhir**, bukan nilai tertinggi.
- Bobot `C/D` diasumsikan 1,50 dan nilai berbobot 0,00 diasumsikan `E`, karena tabel petunjuk mengandung kekeliruan tipografis.
- Query favorit memakai `DENSE_RANK()` agar mata kuliah yang seri pada batas peringkat tidak dihilangkan.
