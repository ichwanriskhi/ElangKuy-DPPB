import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:elangkuy/models/barang_model.dart' as barang_model;
import 'package:elangkuy/models/penawaran_model.dart' as penawaran_model;
import 'package:elangkuy/services/auth_service.dart';
import 'dart:io';

class ApiService {
  static const String baseUrl = 'http://192.168.0.105:8000/api';
  static const String imageBaseUrl = 'http://192.168.0.105:8000/storage/';

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String passwordConfirmation,
    String? nama,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          if (nama != null) 'nama': nama,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': data,
          'message': data['message'] ?? 'Registrasi berhasil',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registrasi gagal',
          'errors': data['errors'] ?? {},
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
        'errors': {},
      };
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Login berhasil',
          'token': data['data']['token'],
          'user': data['data']['pengguna'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login gagal',
          'errors': data['errors'] ?? {},
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
        'errors': {},
      };
    }
  }

  static Future<Map<String, dynamic>> registerSeller({
    required String email,
    required String password,
    required String passwordConfirmation,
    String? name,
    String? shopName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register-seller'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          if (name != null) 'name': name,
          if (shopName != null) 'shop_name': shopName,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': data,
          'message': data['message'] ?? 'Registrasi seller berhasil',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registrasi seller gagal',
          'errors': data['errors'] ?? {},
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
        'errors': {},
      };
    }
  }

  static Future<List<barang_model.Barang>> getApprovedBarangForBuyer({
    String? search,
    String? kategori,
    String? kondisi,
    String? lokasi,
    int? hargaMin,
    int? hargaMax,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Token tidak tersedia');
      }

      final url = Uri.parse('$baseUrl/barang/approved-pembeli').replace(
        queryParameters: {
          if (search != null) 'search': search,
          if (kategori != null) 'kategori': kategori,
          if (kondisi != null) 'kondisi': kondisi,
          if (lokasi != null) 'lokasi': lokasi,
          if (hargaMin != null) 'harga_min': hargaMin.toString(),
          if (hargaMax != null) 'harga_max': hargaMax.toString(),
        },
      );

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> items = data['data']['items'];
        return items.map((item) => barang_model.Barang.fromJson(item)).toList();
      } else {
        throw Exception(data['message'] ?? 'Gagal memuat data barang');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  static Future<barang_model.BarangDetail> getBarangDetail(String id) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Token tidak tersedia');

      final response = await http.get(
        Uri.parse('$baseUrl/barang/detail-pembeli/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return barang_model.BarangDetail.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'Gagal mendapatkan detail barang');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  static Future<List<barang_model.Barang>> getSimilarProducts(
    String kategoriId,
  ) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Token tidak tersedia');

      final response = await http.get(
        Uri.parse('$baseUrl/barang/kategori/$kategoriId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> items = data['data']['items'];
        return items.map((item) => barang_model.Barang.fromJson(item)).toList();
      } else {
        throw Exception(data['message'] ?? 'Gagal memuat data barang serupa');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  static Future<penawaran_model.PenawaranResponse> getPenawaranHistory() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Token tidak tersedia');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/penawaran/aktivitas'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return penawaran_model.PenawaranResponse.fromJson(data);
      } else {
        throw Exception(
          data['message'] ?? 'Gagal memuat data history penawaran',
        );
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Token tidak tersedia');

      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data['data'],
          'message': data['message'] ?? 'Berhasil mendapatkan data profil',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mendapatkan data profil',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? nama,
    String? telepon,
    String? alamat,
    String? bank,
    String? noRekening,
    File? foto,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Token tidak tersedia');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/profile/update'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      if (nama != null) request.fields['nama'] = nama;
      if (telepon != null) request.fields['telepon'] = telepon;
      if (alamat != null) request.fields['alamat'] = alamat;
      if (bank != null) request.fields['bank'] = bank;
      if (noRekening != null) request.fields['no_rekening'] = noRekening;

      if (foto != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'foto',
            foto.path,
            filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        );
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data['data'],
          'message': data['message'] ?? 'Profil berhasil diperbarui',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal memperbarui profil',
          'errors': data['errors'] ?? {},
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
        'errors': {},
      };
    }
  }

  static Future<Map<String, dynamic>> submitBid({
    required String lelangId,
    required int penawaranHarga,
    required int uangMuka,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        throw Exception('Token tidak tersedia');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/penawaran'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id_lelang': lelangId,
          'penawaran_harga': penawaranHarga,
          'uang_muka': uangMuka,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Penawaran berhasil dikirim',
          'data': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal mengirim penawaran',
          'errors': data['errors'] ?? {},
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
        'errors': {},
      };
    }
  }

  static Future<Map<String, dynamic>> logout() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) throw Exception('Token tidak tersedia');

      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Logout berhasil',
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal logout'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }
}
