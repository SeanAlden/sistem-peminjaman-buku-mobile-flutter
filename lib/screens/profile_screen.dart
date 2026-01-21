// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/blocs/auth/auth_bloc.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/blocs/auth/auth_event.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/blocs/auth/auth_state.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/screens/login_screen.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Profile")),
//       body: BlocListener<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthUnauthenticated) {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (_) => const LoginScreen()),
//               (route) => false,
//             );
//           }
//         },
//         child: Center(
//           child: Column(
//             children: [
//               Text("Profile Screen"),
//               ElevatedButton(
//                 onPressed: () {
//                   context.read<AuthBloc>().add(LogoutEvent());
//                 },
//                 child: const Text("Logout"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/auth/auth_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/auth/auth_event.dart';
import 'package:sistem_peminjaman_buku_mobile_app/const/api_url.dart';
import 'package:sistem_peminjaman_buku_mobile_app/const/color.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String email = "";
  String? profileImage;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    // final prefs = await SharedPreferences.getInstance();
    // final user = prefs.getString("auth_user");

    // if (user != null) {
    //   final data = jsonDecode(user);
    //   setState(() {
    //     email = data['email'];
    //     profileImageUrl = data['profile_image'];
    //     profileImage =
    //         'https://cellar-c2.services.clever-cloud.com/book-image-bucket/$profileImageUrl';
    //   });
    // }

    final prefs = await SharedPreferences.getInstance();

    // Load user name dari local storage
    final userJson = prefs.getString('auth_user');
    if (userJson != null) {
      try {
        final user = jsonDecode(userJson);
        setState(() {
          email = user['email'] ?? 'Guest';
        });
      } catch (_) {}
    }

    // Load profile image dari endpoint
    try {
      final token = prefs.getString('auth_token');
      if (token != null) {
        final uri =
            Uri.parse('$baseurl/api/user/profile-image');
        final res = await http.get(uri, headers: {
          'Authorization': 'Bearer $token',
        });

        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          if (data['profile_image'] != null && data['profile_image'] != "") {
            setState(() {
              profileImage = data['profile_image'];
            });
          }
        }
      }
    } catch (_) {
      // jika error, biarkan profileImage tetap null
    }
  }

  void _logout() {
    context.read<AuthBloc>().add(LogoutEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: orangeThemeColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 56,
              backgroundImage: profileImage != null
                  ? NetworkImage(profileImage!)
                  : const AssetImage("assets/profile.png") as ImageProvider,
            ),
            const SizedBox(height: 12),
            Text(email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            _item(
              Icons.person_outline,
              "Edit Profile",
              () => Navigator.pushNamed(context, "/edit-profile"),
            ),
            _item(
              Icons.lock_outline,
              "Edit Password",
              () => Navigator.pushNamed(context, "/edit-password"),
            ),
            _item(
              Icons.favorite,
              "Favorite Books",
              () => Navigator.pushNamed(context, "/favorite-books"),
            ),
            _item(
              Icons.logout,
              "Logout",
              _logout,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(IconData icon, String text, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey),
      title: Text(text, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }
}
