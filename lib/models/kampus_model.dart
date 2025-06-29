class Kampus {
  final int id;
  final String nama;
  final String alamat;
  final String noTelpon; // Disesuaikan dengan `no_telpon` di Laravel
  final String kategori;
  final double latitude;
  final double longitude;
  final String jurusan;

  Kampus({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.noTelpon,
    required this.kategori,
    required this.latitude,
    required this.longitude,
    required this.jurusan,
  });

  // Parse dari JSON (misal dari Laravel)
  factory Kampus.fromJson(Map<String, dynamic> json) {
    return Kampus(
      id: json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      noTelpon: json['no_telpon'], // Sama dengan key Laravel
      kategori: json['kategori'],
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      jurusan: json['jurusan'],
    );
  }

  // Convert ke JSON (saat dikirim ke Laravel)
  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'alamat': alamat,
      'no_telpon': noTelpon,
      'kategori': kategori,
      'latitude': latitude,
      'longitude': longitude,
      'jurusan': jurusan,
    };
  }
}
