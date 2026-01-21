import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_peminjaman_buku_mobile_app/const/api_url.dart';

class AuthRepository {
  SharedPreferences? prefs;
  String? token;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs!.getString("auth_token");
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse("$baseurl/api/login");

    final response = await http.post(
      url,
      body: {
        "email": email,
        "password": password,
      },
    );

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body)
    };
  }

  Future<Map<String, dynamic>> register(String name, String email, String phone,
      String password, String confirmPassword) async {
    final url = Uri.parse("$baseurl/api/register");

    final response = await http.post(
      url,
      body: {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "password_confirmation": confirmPassword
      },
    );

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body)
    };
  }

  Future<Map<String, dynamic>> logout() async {
    final url = Uri.parse("$baseurl/api/logout");

    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Logout gagal: ${response.body}");
    }
  }
}
