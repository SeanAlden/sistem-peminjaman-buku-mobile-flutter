import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/auth/auth_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/auth/auth_event.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/auth/auth_state.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/profile/profile_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/profile/profile_event.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/profile/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final user = jsonDecode(prefs.getString("auth_user")!);
    nameCtrl.text = user['name'];
    emailCtrl.text = user['email'];
  }

  void _submit() {
    context
        .read<ProfileBloc>()
        .add(UpdateProfileEvent(nameCtrl.text, emailCtrl.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Nama")),
              const SizedBox(height: 20),
              TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text("Simpan")),
            ],
          ),
        ),
      ),
    );
  }
}
