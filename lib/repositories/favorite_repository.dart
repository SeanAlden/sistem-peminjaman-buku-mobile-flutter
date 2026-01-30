import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_peminjaman_buku_mobile_app/const/api_url.dart';

class FavoriteRepository {

  Future<List<dynamic>> fetchFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final res = await http.get(
      Uri.parse('$baseurl/api/favorites'),
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
      final res = await http.delete(
        Uri.parse('$baseurl/api/favorites'),
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
      final res = await http.post(
        Uri.parse('$baseurl/api/favorites'),
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
