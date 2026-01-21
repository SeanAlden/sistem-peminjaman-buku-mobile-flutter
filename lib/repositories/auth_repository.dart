// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthRepository {
//   static const String baseUrl =
//       "https://sistem-peminjaman-buku-admin.vercel.app/api";
//   SharedPreferences prefs = SharedPreferences.getInstance();

//   String? token = prefs.getString("auth_token");

//   Future<Map<String, dynamic>> login(String email, String password) async {
//     final url = Uri.parse("$baseUrl/api/login");

//     final response = await http.post(
//       url,
//       body: {
//         "email": email,
//         "password": password,
//       },
//     );

//     return {
//       "statusCode": response.statusCode,
//       "body": jsonDecode(response.body)
//     };
//   }

//   Future<Map<String, dynamic>> register(String name, String email, String phone,
//       String password, String confirmPassword) async {
//     final url = Uri.parse("$baseUrl/api/register");

//     final response = await http.post(
//       url,
//       body: {
//         "name": name,
//         "email": email,
//         "phone": phone,
//         "password": password,
//         "password_confirmation": confirmPassword
//       },
//     );

//     return {
//       "statusCode": response.statusCode,
//       "body": jsonDecode(response.body)
//     };
//   }

//   Future<Map<String, dynamic>> logout() async {
//     final url = Uri.parse('$baseUrl/logout');

//     final response = await http.post(
//       url,
//       headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
//     );

//     if (response.statusCode == 201) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception("Logout gagal: ${response.body}");
//     }
//   }
// }

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_peminjaman_buku_mobile_app/const/api_url.dart';

class AuthRepository {
  // static const String baseUrl =
  //     "https://sistem-peminjaman-buku-admin.vercel.app/api";

  final Dio dio = Dio(
    BaseOptions(
      // baseUrl: "https://sistem-peminjaman-buku-admin.vercel.app",
      baseUrl: "https://f3abd2234c46.ngrok-free.app",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  SharedPreferences? prefs;
  String? token;

  /// Panggil ini sebelum menggunakan repository
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

  Future<Map<String, dynamic>> updateProfile(String name, String email) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs!.getString("auth_token");

    final url = Uri.parse("$baseurl/api/user/update");

    // final res = await dio.put(
    //   "/api/api/user/update",
    //   data: {"name": name, "email": email},
    //   options: Options(headers: {
    //     "Authorization": "Bearer $token",
    //     "Accept": "application/json",
    //   }),
    // );

    // return res.data;

    final response = await http.put(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        "name": name,
        "email": email,
      },
    );

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body)
    };
  }

  Future<void> updatePassword(
    String current,
    String newPass,
    String confirm,
  ) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs!.getString("auth_token");

    await dio.put(
      "/api/api/user/password",
      data: {
        "current_password": current,
        "new_password": newPass,
        "new_password_confirmation": confirm,
      },
      options: Options(headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      }),
    );
  }
}
