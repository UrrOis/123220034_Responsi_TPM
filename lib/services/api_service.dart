import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/phone.dart';

class APIService {
  static const String baseUrl =
      'https://tpm-api-responsi-e-f-872136705893.us-central1.run.app/api/v1';

  static Future<List<Phone>> getPhones() async {
    final url = Uri.parse('$baseUrl/phones');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Phone.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load phones');
      }
    } catch (e) {
      throw Exception('Error fetching phones: $e');
    }
  }

  static Future<Phone> getPhone(String id) async {
    final url = Uri.parse('$baseUrl/phones/$id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Phone.fromJson(json.decode(response.body));
      } else {
        throw Exception('Phone not found');
      }
    } catch (e) {
      throw Exception('Error fetching phone: $e');
    }
  }

  static Future<bool> createPhone(Phone phone) async {
    final url = Uri.parse('$baseUrl/phones');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(phone.toJson()),
      );
      return response.statusCode == 201;
    } catch (e) {
      throw Exception('Error creating phone: $e');
    }
  }

  static Future<bool> updatePhone(String id, Phone phone) async {
    final url = Uri.parse('$baseUrl/phones/$id');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(phone.toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error updating phone: $e');
    }
  }

  static Future<bool> deletePhone(String id) async {
    final url = Uri.parse('$baseUrl/phones/$id');
    try {
      final response = await http.delete(url);
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error deleting phone: $e');
    }
  }
}
