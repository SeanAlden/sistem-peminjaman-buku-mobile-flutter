import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_peminjaman_buku_mobile_app/const/api_url.dart';

class ProfileRepository {
  SharedPreferences? prefs;
  String? token;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs!.getString("auth_token");
  }

  Future<Map<String, dynamic>> updateProfile(String name, String email) async {
    prefs = await SharedPreferences.getInstance();
    token = prefs!.getString("auth_token");

    final url = Uri.parse("$baseurl/api/user/update");

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

  // Future<void> updatePassword(
  //   String current,
  //   String newPass,
  //   String confirm,
  // ) async {
  //   prefs = await SharedPreferences.getInstance();
  //   token = prefs!.getString("auth_token");

  //   await dio.put(
  //     "/api/user/password",
  //     data: {
  //       "current_password": current,
  //       "new_password": newPass,
  //       "new_password_confirmation": confirm,
  //     },
  //     options: Options(headers: {
  //       "Authorization": "Bearer $token",
  //       "Accept": "application/json",
  //     }),
  //   );
  // }

  Future<Map<String, dynamic>> updatePassword(
    String current,
    String newPass,
    String confirm,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    final uri = Uri.parse("$baseurl/api/user/password");

    final response = await http.put(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      // body: jsonEncode({
      //   "current_password": current,
      //   "new_password": newPass,
      //   "new_password_confirmation": confirm,
      // }),

      body: {
        "current_password": current,
        "new_password": newPass,
        "new_password_confirmation": confirm,
      },
    );

    return {
      "statusCode": response.statusCode,
      "body": jsonDecode(response.body)
    };

    // if (response.statusCode != 200) {
    //   throw Exception(
    //     "Failed to update password: ${response.body}",
    //   );
    // }
  }

  // Future<Map<String, dynamic>> updateProfileImage(String imagePath) async {
  //   prefs = await SharedPreferences.getInstance();
  //   token = prefs!.getString("auth_token");

  //   final formData = FormData.fromMap({
  //     'profile_image': await MultipartFile.fromFile(imagePath),
  //   });

  //   final response = await dio.post(
  //     '/api/user/update-profile-image',
  //     data: formData,
  //     options: Options(headers: {
  //       'Authorization': 'Bearer $token',
  //       'Accept': 'application/json',
  //     }),
  //   );

  //   return response.data;
  // }

  Future<Map<String, dynamic>> updateProfileImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("auth_token");

    final uri = Uri.parse("$baseurl/api/user/update-profile-image");

    final request = http.MultipartRequest("POST", uri);

    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        "profile_image",
        imagePath,
      ),
    );

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode != 200) {
      throw Exception(
        "Failed to update profile image: $responseBody",
      );
    }

    return jsonDecode(responseBody) as Map<String, dynamic>;
  }
}
