// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:elangkuy/models/barang_model.dart';
import 'package:elangkuy/services/auth_service.dart';

class ApiService {
  // Ganti dengan URL API Anda
  static const String baseUrl = 'http://192.168.0.101:8000/api';

  // Untuk testing lokal, gunakan:
  // static const String baseUrl = 'http://10.0.2.2:8000/api'; // Android Emulator
  // static const String baseUrl = 'http://localhost:8000/api'; // iOS Simulator

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
        'token': data['data']['token'],  // Updated path to token
        'user': data['data']['pengguna'],  // Updated path to user data
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

  static Future<BarangResponse> getApprovedBarangForBuyer({
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
        return BarangResponse.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? 'Gagal memuat data barang');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }
}
