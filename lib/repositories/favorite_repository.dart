// // lib/repositories/favorite_repository.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class FavoriteRepository {
//   static const String baseUrl = "https://sistem-peminjaman-buku-admin.vercel.app/api";

//   Future<List<dynamic>> fetchFavorites() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');
//     final uri = Uri.parse('$baseUrl/api/favorites');

//     final response = await http.get(uri, headers: {
//       if (token != null) 'Authorization': 'Bearer $token',
//       'Accept': 'application/json',
//     });

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       if (data['success'] == true) {
//         return List<dynamic>.from(data['data']);
//       }
//       throw Exception('Fetch favorites failed: ${data}');
//     } else {
//       throw Exception('Fetch favorites failed: ${response.statusCode}');
//     }
//   }

//   Future<bool> toggleFavorite(int bookId, {required bool currentlyFavorited}) async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');
//     final uri = Uri.parse('$baseUrl/api/favorites');

//     final response = await http.post(
//       uri,
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       },
//       body: jsonEncode({'book_id': bookId}),
//     );

//     // Note: In the React code they used DELETE for remove — backend may expect POST toggle or DELETE with body.
//     // Here we assume POST toggles (create), and backend will respond success. If your backend uses DELETE for remove,
//     // you should call DELETE with body `{ book_id }` or a different endpoint. Adjust if needed.

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final data = jsonDecode(response.body);
//       return data['success'] == true;
//     } else {
//       throw Exception('Toggle favorite failed: ${response.statusCode}');
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_peminjaman_buku_mobile_app/repositories/book_repository.dart';

class FavoriteRepository {
  static const String baseUrl = BookRepository.baseUrl;

  Future<List<dynamic>> fetchFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final res = await http.get(
      Uri.parse('$baseUrl/api/favorites'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      return json['data'];
    } else {
      throw Exception('Failed to fetch favorites');
    }
  }

  Future<void> toggleFavorite(int bookId, {required bool currentlyFavorited}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (currentlyFavorited) {
      // USER SUDAH FAVORIT → HAPUS FAVORIT
      final res = await http.delete(
        Uri.parse('$baseUrl/api/favorites'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'book_id': bookId}),
      );

      if (res.statusCode != 200) {
        throw Exception('Failed to remove favorite');
      }
    } else {
      // USER BELUM FAVORIT → TAMBAHKAN FAVORIT
      final res = await http.post(
        Uri.parse('$baseUrl/api/favorites'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'book_id': bookId}),
      );

      if (res.statusCode != 200) {
        throw Exception('Failed to add favorite');
      }
    }
  }
}
