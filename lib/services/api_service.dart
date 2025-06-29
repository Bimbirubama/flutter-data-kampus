import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kampus_model.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.208.178:8000/api/kampus';

  /// ✅ Ambil semua data kampus
  static Future<List<Kampus>> fetchKampus() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      print('FETCH STATUS: ${response.statusCode}');
      print('FETCH BODY: ${response.body}');

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'] ?? '';

        // Pastikan response berupa JSON
        if (!contentType.contains('application/json')) {
          throw Exception('Format data tidak valid (bukan JSON)');
        }

        final decoded = json.decode(response.body);

        if (decoded is List) {
          return decoded.map((item) => Kampus.fromJson(item)).toList();
        } else if (decoded is Map && decoded['data'] is List) {
          return (decoded['data'] as List)
              .map((item) => Kampus.fromJson(item))
              .toList();
        } else {
          throw Exception('Format JSON tidak dikenali');
        }
      } else {
        throw Exception('Gagal memuat data kampus (${response.statusCode})');
      }
    } catch (e) {
      print('❗ Fetch error: $e');
      rethrow;
    }
  }

  /// ✅ Tambah kampus
 static Future<bool> addKampus(Kampus kampus) async {
  try {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(kampus.toJson()),
    );

    print('ADD STATUS: \${response.statusCode}');
    print('ADD BODY: \${response.body}');

    return response.statusCode == 201 || response.statusCode == 200;
  } catch (e) {
    print('❗ Error saat tambah kampus: \$e');
    return false;
  }
}

  /// ✅ Update kampus
  static Future<bool> updateKampus(int id, Kampus kampus) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(kampus.toJson()),
      );

      print('UPDATE STATUS: ${response.statusCode}');
      print('UPDATE BODY: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('❗ Error saat update kampus: $e');
      return false;
    }
  }

  /// ✅ Hapus kampus
  static Future<bool> deleteKampus(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      print('DELETE STATUS: ${response.statusCode}');
      print('DELETE BODY: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('❗ Error saat hapus kampus: $e');
      return false;
    }
  }
}
