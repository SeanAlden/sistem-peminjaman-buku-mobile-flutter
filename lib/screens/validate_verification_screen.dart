import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sistem_peminjaman_buku_mobile_app/const/api_url.dart';
import 'package:sistem_peminjaman_buku_mobile_app/const/color.dart';
import 'package:sistem_peminjaman_buku_mobile_app/screens/reset_password_screen.dart';

class ValidateVerificationScreen extends StatefulWidget {
  final String email;
  const ValidateVerificationScreen({super.key, required this.email});

  @override
  State<ValidateVerificationScreen> createState() =>
      _ValidateVerificationScreenState();
}

class _ValidateVerificationScreenState
    extends State<ValidateVerificationScreen> {
  final List<TextEditingController> ctrls =
      List.generate(4, (_) => TextEditingController());

  bool loading = false;

  bool resendLoading = false;

  int resendSeconds = 60;
  Timer? resendTimer;

  int maxResend = 3;
  int resendCount = 0;

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  @override
  void dispose() {
    resendTimer?.cancel();
    for (final c in ctrls) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> verifyCode() async {
    final code = ctrls.map((e) => e.text).join();

    if (code.length < 4) return;

    setState(() => loading = true);

    final response = await http.post(
      Uri.parse("$baseurl/api/verify-code"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': widget.email,
        'code': code,
      }),
    );

    setState(() => loading = false);

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(email: widget.email),
        ),
      );
    } else {
      final msg = jsonDecode(response.body)['message'];
      showAlert(msg);
    }
  }

  Future<void> resendOtp() async {
    if (resendCount >= maxResend) return;

    setState(() => resendLoading = true);

    final response = await http.post(
      Uri.parse("$baseurl/api/forgot-password"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': widget.email}),
    );

    setState(() => resendLoading = false);

    if (response.statusCode == 200) {
      resendCount++;

      for (final c in ctrls) {
        c.clear();
      }

      FocusScope.of(context).requestFocus(FocusNode());
      startResendTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Kode OTP dikirim ulang (${maxResend - resendCount}x tersisa)",
          ),
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
        title: const Text("Error"),
        content: Text(msg),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text("OK"))
        ],
      ),
    );
  }

  void startResendTimer() {
    resendTimer?.cancel();
    setState(() => resendSeconds = 60);

    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds == 0) {
        timer.cancel();
      } else {
        setState(() => resendSeconds--);
      }
    });
  }

  Widget codeBox(int index) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: ctrls[index],
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).nextFocus();
          }

          if (ctrls.every((c) => c.text.isNotEmpty)) {
            verifyCode();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Verification"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: orangeThemeColor,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: size.height -
                MediaQuery.of(context).viewInsets.bottom -
                kToolbarHeight,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.verified_outlined,
                  size: 64,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Masukkan Kode Verifikasi",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Kode verifikasi telah dikirim ke\n${widget.email}",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, codeBox),
                ),
                const SizedBox(height: 32),
                resendLoading
                    ? const CircularProgressIndicator(strokeWidth: 2)
                    : TextButton(
                        onPressed:
                            (resendSeconds == 0 && resendCount < maxResend)
                                ? resendOtp
                                : null,
                        child: resendCount >= maxResend
                            ? const Text(
                                "Batas kirim ulang tercapai",
                                style: TextStyle(color: Colors.red),
                              )
                            : resendSeconds == 0
                                ? const Text("Kirim ulang kode")
                                : Text(
                                    "Kirim ulang dalam 00:${resendSeconds.toString().padLeft(2, '0')}",
                                  ),
                      ),
                if (loading) const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  "Kode akan diverifikasi secara otomatis",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
