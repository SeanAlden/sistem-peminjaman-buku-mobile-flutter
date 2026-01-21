// lib/repositories/book_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookRepository {
  static const String baseUrl = "https://sistem-peminjaman-buku-admin.vercel.app/api";
  // static const String baseUrl = "https://f3abd2234c46.ngrok-free.app";

  Future<List<dynamic>> fetchBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final uri = Uri.parse('$baseUrl/api/books');
    final response = await http.get(uri, headers: {
      if (token != null) 'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) return List<dynamic>.from(data['data']);
      throw Exception('Fetch books failed: ${data}');
    } else {
      throw Exception('Fetch books failed: ${response.statusCode}');
    }
  }
}
