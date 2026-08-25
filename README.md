# Ubuntu 24.04.1 LTS — Live Server (amd64) ISO

ISO Ubuntu Server yang dipecah jadi 2 bagian, karena ukurannya **2.77 GB** dan GitHub nggak
bisa nerima file sebesar itu (`git push` maksimal 100 MB/file, Git LFS maksimal 2 GiB/file).
Jadi part-nya ditaruh di **[Releases](../../releases/tag/v24.04.1)**, bukan di dalam git history.

| | |
|---|---|
| File | `ubuntu-24.04.1-live-server-amd64.iso` |
| Ukuran | 2.773.874.688 byte (± 2,58 GiB) |
| SHA256 | `e240e4b801f7bb68c20d1356b60968ad0c33a41d00d828e74ceb3364a0317be9` |

---

## Cara pakai (paling gampang)

Clone repo ini, lalu jalanin salah satu script. Script-nya otomatis **download part → cek
checksum → gabungin → verifikasi hasil akhir**. Nggak perlu download manual.

```bash
git clone https://github.com/T042JasonKennethLay/ISO.git
cd ISO
```

**Windows (PowerShell):**
```powershell
.\reassemble.ps1
```
> Kalau kena error execution policy, jalanin:
> `powershell -ExecutionPolicy Bypass -File .\reassemble.ps1`

**Linux / macOS / Git Bash:**
```bash
./reassemble.sh
```

Selesai — file `ubuntu-24.04.1-live-server-amd64.iso` muncul di folder yang sama.
Butuh ruang kosong **± 5,6 GB** waktu proses (part + hasil gabungan), setelah itu part-nya
boleh dihapus.

---

## Cara manual (kalau nggak mau pakai script)

1. Download kedua file dari halaman [Releases](../../releases/tag/v24.04.1):
   - `ubuntu-24.04.1-live-server-amd64.iso.part00` (1.468.006.400 byte)
   - `ubuntu-24.04.1-live-server-amd64.iso.part01` (1.305.868.288 byte)

2. Gabungkan — **urutan wajib part00 dulu, baru part01**:

   Windows (CMD):
   ```cmd
   copy /b ubuntu-24.04.1-live-server-amd64.iso.part00 + ubuntu-24.04.1-live-server-amd64.iso.part01 ubuntu-24.04.1-live-server-amd64.iso
   ```

   Linux / macOS:
   ```bash
   cat ubuntu-24.04.1-live-server-amd64.iso.part0* > ubuntu-24.04.1-live-server-amd64.iso
   ```

3. Verifikasi:

   Windows (PowerShell):
   ```powershell
   Get-FileHash ubuntu-24.04.1-live-server-amd64.iso -Algorithm SHA256
   ```

   Linux / macOS:
   ```bash
   sha256sum -c ORIGINAL.sha256
   ```

   Hasilnya harus sama persis dengan SHA256 di tabel atas. Kalau beda, berarti download-nya
   korup atau urutan gabungnya kebalik — ulangi.

---

## Isi repo

| File | Fungsi |
|---|---|
| `reassemble.ps1` | Script Windows: download + gabung + verifikasi |
| `reassemble.sh` | Script Linux/macOS: download + gabung + verifikasi |
| `ORIGINAL.sha256` | Checksum ISO utuh |
| `PARTS.sha256` | Checksum tiap part |

Part-nya sendiri **tidak** ada di git — ada di Releases (lihat `.gitignore`).

---

## Catatan

Ini ISO resmi Ubuntu yang bisa diunduh gratis dari
**<https://releases.ubuntu.com/24.04.1/>**. Kalau koneksi ke sana lancar, download langsung
dari situs resmi jauh lebih cepat dan lebih aman daripada lewat repo ini — checksum di atas
bisa dicocokkan dengan `SHA256SUMS` milik Ubuntu. Repo ini gunanya cuma buat bagi-bagi file
yang sudah terlanjur ada di lokal.

Ubuntu dirilis di bawah lisensinya masing-masing; repo ini cuma mendistribusikan ulang, tanpa
modifikasi apa pun.
