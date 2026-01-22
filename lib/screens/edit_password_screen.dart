import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/profile/profile_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/profile/profile_event.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/profile/profile_state.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({super.key});

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final currentCtrl = TextEditingController();
  final newCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  void _submit() {
    if (newCtrl.text != confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password baru tidak sama")),
      );
      return;
    }
    context.read<ProfileBloc>().add(
          UpdatePasswordEvent(
            currentCtrl.text,
            newCtrl.text,
            confirmCtrl.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ganti Password")),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is PasswordUpdated) {
            Navigator.pop(context);
          }
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(controller: currentCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Password Lama")),
              const SizedBox(height: 20),
              TextField(controller: newCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Password Baru")),
              const SizedBox(height: 20),
              TextField(controller: confirmCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Konfirmasi Password")),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text("Simpan")),
            ],
          ),
        ),
      ),
    );
  }
}
