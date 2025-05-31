import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/phone.dart';

class ApiService {
  static const String baseUrl =
      'https://tpm-api-responsi-e-f-872136705893.us-central1.run.app/api/v1';

  static Future<List<Smartphone>> getSmartphones() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/phones'),
        headers: {'Accept': 'application/json'},
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> data = decoded['data'];
        return data.map((e) => Smartphone.fromJson(e)).toList();
      } else {
        throw Exception('Gagal memuat data. Status: ${response.statusCode}');
      }
    } catch (e) {
      print("ERROR PARSING: $e");
      throw Exception("Format tidak valid atau bukan JSON");
    }
  }

  static Future<void> createSmartphone(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/phones'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(body),
    );
    if (response.statusCode != 201) {
      throw Exception('Gagal menambahkan data. Status: ${response.statusCode}');
    }
  }

  static Future<void> updateSmartphone(
    int id,
    Map<String, dynamic> body,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/phones/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(body),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal memperbarui data. Status: ${response.statusCode}');
    }
  }

  static Future<void> deleteSmartphone(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/phones/$id'),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus data. Status: ${response.statusCode}');
    }
  }
}
