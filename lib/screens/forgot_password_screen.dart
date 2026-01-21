import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sistem_peminjaman_buku_mobile_app/const/api_url.dart';
import 'validate_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailCtrl = TextEditingController();
  bool loading = false;

  Future<void> submitEmail() async {
    if (emailCtrl.text.isEmpty) {
      showAlert("Email wajib diisi");
      return;
    }

    setState(() => loading = true);

    final response = await http.post(
      Uri.parse("$baseurl/api/forgot-password"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': emailCtrl.text}),
    );

    setState(() => loading = false);

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ValidateVerificationScreen(email: emailCtrl.text),
        ),
      );
    } else {
      final msg = jsonDecode(response.body)['message'];
      showAlert(msg);
    }
  }

  void showAlert(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Info"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text("Forgot Password")),
  //     body: Padding(
  //       padding: const EdgeInsets.all(20),
  //       child: Column(
  //         children: [
  //           TextField(
  //             controller: emailCtrl,
  //             decoration: const InputDecoration(
  //               labelText: "Email",
  //               border: OutlineInputBorder(),
  //             ),
  //           ),
  //           const SizedBox(height: 20),
  //           SizedBox(
  //             width: double.infinity,
  //             height: 45,
  //             child: loading
  //                 ? const Center(child: CircularProgressIndicator())
  //                 : ElevatedButton(
  //                     onPressed: submitEmail,
  //                     child: const Text("Submit"),
  //                   ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lupa Password"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // ICON
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_reset,
                size: 60,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 24),

            // TITLE
            const Text(
              "Lupa Password?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // DESCRIPTION
            Text(
              "Masukkan email yang terdaftar. Kami akan mengirimkan kode verifikasi untuk mengatur ulang password Anda.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 30),

            // EMAIL INPUT
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "contoh@email.com",
                helperText: "Gunakan email yang terdaftar di akun Anda",
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // BUTTON
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: loading ? null : submitEmail,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: loading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text("Mengirim permintaan..."),
                        ],
                      )
                    : const Text(
                        "Kirim Kode Verifikasi",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // INFO TEXT
            Text(
              "Jika email terdaftar, kode verifikasi akan dikirim.",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
