class Barang {
  final String idBarang;
  final String namaBarang;
  final int hargaAwal;
  final String lokasi;
  final String deskripsi;
  final String kondisi;
  final String status;
  final String fotoUtama;
  final List<String> foto;
  final Map<String, dynamic> kategori;
  final Map<String, dynamic>? lelang;

  Barang({
    required this.idBarang,
    required this.namaBarang,
    required this.hargaAwal,
    required this.lokasi,
    required this.deskripsi,
    required this.kondisi,
    required this.status,
    required this.fotoUtama,
    required this.foto,
    required this.kategori,
    this.lelang,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      idBarang: json['id_barang'].toString(),
      namaBarang: json['nama_barang'],
      hargaAwal: json['harga_awal'] is int ? json['harga_awal'] : int.parse(json['harga_awal'].toString()),
      lokasi: json['lokasi'],
      deskripsi: json['deskripsi'],
      kondisi: json['kondisi'],
      status: json['status'],
      fotoUtama: json['foto_utama'],
      foto: List<String>.from(json['foto'] ?? []),
      kategori: Map<String, dynamic>.from(json['kategori'] ?? {}),
      lelang: json['lelang'] != null ? Map<String, dynamic>.from(json['lelang']) : null,
    );
  }

  String get hargaFormatted {
    return 'Rp. ${hargaAwal.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }
}

class BarangResponse {
  final List<Barang> items;
  final Map<String, dynamic> pagination;

  BarangResponse({
    required this.items,
    required this.pagination,
  });

  factory BarangResponse.fromJson(Map<String, dynamic> json) {
    return BarangResponse(
      items: (json['items'] as List).map((i) => Barang.fromJson(i)).toList(),
      pagination: Map<String, dynamic>.from(json['pagination'] ?? {}),
    );
  }
}