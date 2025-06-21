class PenawaranResponse {
  final List<Penawaran> items;
  final Map<String, dynamic> stats;

  PenawaranResponse({
    required this.items,
    required this.stats,
  });

  factory PenawaranResponse.fromJson(Map<String, dynamic> json) {
    return PenawaranResponse(
      items: (json['data']['items'] as List)
          .map((item) => Penawaran.fromJson(item))
          .toList(),
      stats: json['stats'] ?? {},
    );
  }
}

class Penawaran {
  final String idPenawaran;
  final int penawaranHarga;
  final int uangMuka;
  final String waktu;
  final String? statusTawar;
  final int? bayarSisa;
  final String? waktuBs;
  final String? statusBs;
  final Lelang lelang;

  Penawaran({
    required this.idPenawaran,
    required this.penawaranHarga,
    required this.uangMuka,
    required this.waktu,
    this.statusTawar,
    this.bayarSisa,
    this.waktuBs,
    this.statusBs,
    required this.lelang,
  });

  factory Penawaran.fromJson(Map<String, dynamic> json) {
    return Penawaran(
      idPenawaran: json['id_penawaran'].toString(),
      penawaranHarga: json['penawaran_harga'] ?? 0,
      uangMuka: json['uang_muka'] ?? 0,
      waktu: json['waktu'] ?? '',
      statusTawar: json['status_tawar'],
      bayarSisa: json['bayar_sisa'],
      waktuBs: json['waktu_bs'],
      statusBs: json['status_bs'],
      lelang: Lelang.fromJson(json['lelang'] ?? {}),
    );
  }

  String getStatusText() {
    if (statusBs == 'dikonfirmasi') return 'Selesai';
    if (statusTawar == 'win' && statusBs == null) return 'Belum dibayar';
    if (statusTawar == 'win') return 'Menang';
    if (statusTawar == 'banned') return 'Kalah';
    return 'Sedang Berlangsung';
  }
}

class Lelang {
  final String idLelang;
  final String status;
  final String tglDibuka;
  final String tglSelesai;
  final int hargaAkhir;
  final Barang barang;

  Lelang({
    required this.idLelang,
    required this.status,
    required this.tglDibuka,
    required this.tglSelesai,
    required this.hargaAkhir,
    required this.barang,
  });

  factory Lelang.fromJson(Map<String, dynamic> json) {
    return Lelang(
      idLelang: json['id_lelang'].toString(),
      status: json['status'] ?? '',
      tglDibuka: json['tgl_dibuka'] ?? '',
      tglSelesai: json['tgl_selesai'] ?? '',
      hargaAkhir: json['harga_akhir'] ?? 0,
      barang: Barang.fromJson(json['barang'] ?? {}),
    );
  }
}

class Barang {
  final String idBarang;
  final String namaBarang;
  final int hargaAwal;
  final List<String> foto;
  final Kategori? kategori;

  Barang({
    required this.idBarang,
    required this.namaBarang,
    required this.hargaAwal,
    required this.foto,
    this.kategori,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      idBarang: json['id_barang'].toString(),
      namaBarang: json['nama_barang'] ?? 'Nama Barang Tidak Tersedia',
      hargaAwal: json['harga_awal'] ?? 0,
      foto: List<String>.from(json['foto'] ?? []),
      kategori: json['kategori'] != null 
          ? Kategori.fromJson(json['kategori'])
          : null,
    );
  }
}

class Kategori {
  final String idKategori;
  final String namaKategori;

  Kategori({
    required this.idKategori,
    required this.namaKategori,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      idKategori: json['id_kategori'].toString(),
      namaKategori: json['nama_kategori'] ?? '',
    );
  }
}