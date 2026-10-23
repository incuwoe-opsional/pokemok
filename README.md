
# PokéDex


## Deskripsi Aplikasi

PokéDex adalah aplikasi mobile sederhana berbasis Flutter yang menampilkan daftar Pokémon dan informasi detailnya. Aplikasi mengambil data secara dinamis dari PokéAPI, kemudian mengolah respons JSON dan menampilkan hasilnya pada antarmuka aplikasi.

## Fitur Utama

- Menampilkan daftar 151 Pokémon generasi pertama.
- Menampilkan gambar dan nomor Pokédex setiap Pokémon.
- Mencari Pokémon berdasarkan nama atau nomor Pokédex.
- Menampilkan detail Pokémon, meliputi tipe, tinggi, berat, kemampuan, dan statistik dasar.
- Menampilkan indikator loading serta pesan kesalahan ketika data gagal dimuat.
- Mengambil data dari API secara online.

## Teknologi dan Package

- **Flutter** — framework untuk membangun aplikasi mobile.
- **Dart** — bahasa pemrograman yang digunakan.
- **http** — package untuk melakukan HTTP request ke API.
- **PokéAPI** — sumber data Pokémon: <https://pokeapi.co/api/v2/pokemon/>.
- **JSON** — format respons API yang diolah menjadi objek Dart.

PokéAPI dapat digunakan tanpa API key.

## Struktur File Utama

```text
lib/
├── main.dart
├── model/
│   └── pokemon.dart
├── view/
│   ├── home.dart
│   └── pokemon_detail.dart
└── viewmodel/
    └── fetchpokemon.dart
```

## Langkah Menjalankan Aplikasi

### Prasyarat

1. Install Flutter SDK.
2. Install Android Studio beserta Android SDK, atau siapkan perangkat Android yang dapat digunakan untuk menjalankan aplikasi.
3. Pastikan perintah `flutter doctor` tidak menunjukkan masalah penting pada lingkungan pengembangan.

### Menjalankan

1. Clone repositori ini atau unduh kode sumbernya.
2. Buka folder project di Android Studio atau terminal.
3. Pastikan package `http` tercantum di bagian `dependencies` pada file `pubspec.yaml`.
4. Unduh dependency dengan perintah:

   ```bash
   flutter pub get
   ```

5. Jalankan emulator Android atau hubungkan perangkat Android dengan USB debugging aktif.
6. Jalankan aplikasi dengan perintah:

   ```bash
   flutter run
   ```

Aplikasi membutuhkan koneksi internet agar dapat mengambil data dari PokéAPI dan memuat gambar Pokémon.

## Sumber API

- PokéAPI — daftar Pokémon: <https://pokeapi.co/api/v2/pokemon/?limit=151&offset=0>
- PokéAPI — contoh detail Pikachu: <https://pokeapi.co/api/v2/pokemon/25/>

## Catatan

PokéDex ini dibuat untuk keperluan pembelajaran dan tugas UTS mata kuliah Pemrograman Mobile.
