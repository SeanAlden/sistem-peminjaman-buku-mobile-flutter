// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/blocs/auth/auth_bloc.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/blocs/auth/auth_event.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/blocs/profile/profile_bloc.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/blocs/profile/profile_event.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/blocs/profile/profile_state.dart';
// import 'package:sistem_peminjaman_buku_mobile_app/const/color.dart';
// import 'package:image_picker/image_picker.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   late Future<void> _userFuture;
//   String email = "";
//   String? profileImage;
//   String? profileImageUrl;
//   final ImagePicker _picker = ImagePicker();
//   bool uploadingImage = false;

//   @override
//   void initState() {
//     super.initState();
//     context.read<ProfileBloc>().add(LoadProfileEvent());

//     _userFuture = _loadUser();
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final XFile? image = await _picker.pickImage(
//       source: source,
//       imageQuality: 80,
//     );

//     if (image != null) {
//       context.read<ProfileBloc>().add(UpdateProfileImageEvent(image.path));
//     }
//   }

//   Future<void> _loadUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     final userJson = prefs.getString('auth_user');
//     if (userJson != null) {
//       final user = jsonDecode(userJson);

//       setState(() {
//         email = user['email'] ?? 'Guest';
//         profileImage = user['profile_image'];
//       });
//     }
//   }

//   void _logout() {
//     context.read<AuthBloc>().add(LogoutEvent());
//   }

//   void _showImageSourcePicker() {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) => SafeArea(
//         child: Wrap(
//           children: [
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text("Kamera"),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(ImageSource.camera);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text("Galeri"),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(ImageSource.gallery);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile Screen',
//             style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white)),
//         centerTitle: true,
//         backgroundColor: orangeThemeColor,
//         automaticallyImplyLeading: false,
//       ),
//       backgroundColor: Colors.white,
//       body: BlocListener<ProfileBloc, ProfileState>(
//         listener: (context, state) {
//           if (state is ProfileImageUploading) {
//             setState(() {
//               uploadingImage = true;
//             });
//           }

//           if (state is ProfileImageUpdated) {
//             setState(() {
//               uploadingImage = false;
//               profileImage = state.imageUrl;
//             });
//           }

//           if (state is ProfileError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         child: FutureBuilder(
//           future: _userFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState != ConnectionState.done) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             return _buildContent();
//           },
//         ),
//       ),
//     );
//   }

//   Widget _item(IconData icon, String text, VoidCallback onTap, {Color? color}) {
//     return ListTile(
//       leading: Icon(icon, color: color ?? Colors.grey),
//       title: Text(text, style: TextStyle(color: color)),
//       onTap: onTap,
//     );
//   }

//   Widget _buildContent() {
//     return SafeArea(
//       child: Column(
//         children: [
//           const SizedBox(height: 20),
//           Stack(
//             alignment: Alignment.bottomRight,
//             children: [
//               // CircleAvatar(
//               //   radius: 56,
//               //   backgroundImage: profileImage != null
//               //       ? NetworkImage(
//               //           profileImage!
//               //         )
//               //       : const AssetImage("assets/profile.png") as ImageProvider,
//               // ),

//               CircleAvatar(
//                 radius: 56,
//                 backgroundColor: Colors.grey.shade200,
//                 child: ClipOval(
//                   child: Image.network(
//                     // KONDISI 1
//                     profileImage!,
//                     width: 112,
//                     height: 112,
//                     fit: BoxFit.cover,

//                     errorBuilder: (context, error, stackTrace) {
//                       // KONDISI 2
//                       return Image.network(
//                         'https://cellar-c2.services.clever-cloud.com/book-image-bucket/profile_images/${profileImage!}',
//                         width: 112,
//                         height: 112,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           // KONDISI 3 (FINAL FALLBACK)
//                           return Image.asset(
//                             'assets/profile.png',
//                             width: 112,
//                             height: 112,
//                             fit: BoxFit.cover,
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ),

//               GestureDetector(
//                 onTap: _showImageSourcePicker,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: orangeThemeColor,
//                   ),
//                   padding: const EdgeInsets.all(6),
//                   child: const Icon(
//                     Icons.camera_alt,
//                     size: 18,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               if (uploadingImage)
//                 Container(
//                   width: 112,
//                   height: 112,
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.4),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const CircularProgressIndicator(color: Colors.white),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(email, style: const TextStyle(color: Colors.grey)),
//           const SizedBox(height: 24),
//           _item(
//             Icons.person_outline,
//             "Edit Profile",
//             () => Navigator.pushNamed(context, "/edit-profile"),
//           ),
//           _item(
//             Icons.lock_outline,
//             "Edit Password",
//             () => Navigator.pushNamed(context, "/edit-password"),
//           ),
//           _item(
//             Icons.favorite,
//             "Favorite Books",
//             () => Navigator.pushNamed(context, "/favorite-books"),
//           ),
//           _item(
//             Icons.logout,
//             "Logout",
//             _logout,
//             color: Colors.red,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/auth/auth_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/auth/auth_event.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/profile/profile_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/profile/profile_event.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/profile/profile_state.dart';
import 'package:sistem_peminjaman_buku_mobile_app/const/color.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfileEvent());
  }

  void _logout() {
    context.read<AuthBloc>().add(LogoutEvent());
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null && mounted) {
      context.read<ProfileBloc>().add(
            UpdateProfileImageEvent(image.path),
          );
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Kamera"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Galeri"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: orangeThemeColor,
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoaded) {
            return _ProfileContent(
              name: state.name,
              email: state.email,
              profileImage: state.profileImage,
              onEditImage: _showImageSourcePicker,
              onLogout: _logout,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final String name;
  final String email;
  final String? profileImage;
  final VoidCallback onEditImage;
  final VoidCallback onLogout;

  const _ProfileContent({
    required this.name,
    required this.email,
    required this.profileImage,
    required this.onEditImage,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 56,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: profileImage != null &&
                        profileImage!.isNotEmpty
                    ? NetworkImage(profileImage!)
                    : const AssetImage('assets/profile.png') as ImageProvider,
              ),
              GestureDetector(
                onTap: onEditImage,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: orangeThemeColor,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
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
            onLogout,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _item(
    IconData icon,
    String text,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey),
      title: Text(text, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }
}

