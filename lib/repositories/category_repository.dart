// lib/repositories/category_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryRepository {
  static const String baseUrl = "https://sistem-peminjaman-buku-admin.vercel.app/api";

  Future<List<dynamic>> fetchCategories() async {
    final uri = Uri.parse('$baseUrl/api/categories');
    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) return List<dynamic>.from(data['data']);
      throw Exception('Fetch categories failed: ${data}');
    } else {
      throw Exception('Fetch categories failed: ${response.statusCode}');
    }
  }

    Future<List<dynamic>> fetchCategoryDetail(int categoryId) async {
    final uri = Uri.parse("$baseUrl/api/categories/$categoryId");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        return data["data"]["books"] ?? [];
      } else {
        throw Exception(data["message"] ?? "Failed to load category");
      }
    } else {
      throw Exception("Failed to fetch data");
    }
  }
}
