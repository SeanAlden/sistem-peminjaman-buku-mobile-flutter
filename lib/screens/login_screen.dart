import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/const/color.dart';
import 'package:sistem_peminjaman_buku_mobile_app/screens/forgot_password_screen.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import 'register_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final emailCtrl = TextEditingController();
//   final passwordCtrl = TextEditingController();
//   bool loading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Login"),
//         automaticallyImplyLeading: false,
//       ),
//       body: BlocConsumer<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthLoading) {
//             setState(() => loading = true);
//           } else {
//             setState(() => loading = false);
//           }

//           // if (state is AuthAuthenticated) {
//           //   Navigator.pushReplacement(
//           //     context,
//           //     MaterialPageRoute(builder: (_) => const MainTabs()),
//           //   );
//           // }

//           if (state is AuthError) {
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(SnackBar(content: Text(state.message)));
//           }
//         },
//         builder: (context, state) {
//           return Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: emailCtrl,
//                   decoration: const InputDecoration(labelText: "Email"),
//                 ),
//                 TextField(
//                   controller: passwordCtrl,
//                   obscureText: true,
//                   decoration: const InputDecoration(labelText: "Password"),
//                 ),
//                 const SizedBox(height: 20),
//                 loading
//                     ? const CircularProgressIndicator()
//                     : ElevatedButton(
//                         onPressed: () {
//                           context.read<AuthBloc>().add(
//                                 LoginEvent(
//                                   emailCtrl.text,
//                                   passwordCtrl.text,
//                                 ),
//                               );
//                         },
//                         child: const Text("Login"),
//                       ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (_) => const RegisterScreen()),
//                     );
//                   },
//                   child: const Text("Belum punya akun? Register"),
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool obscurePassword = true;

  bool loading = false;

  void showEmptyAlert() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Peringatan"),
        content: const Text("Semua data wajib diisi"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Peringatan"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.grey[100],
  //     appBar: AppBar(
  //       title: const Text("Login"),
  //       centerTitle: true,
  //       automaticallyImplyLeading: false,
  //     ),
  //     body: BlocConsumer<AuthBloc, AuthState>(
  //       listener: (context, state) {
  //         setState(() => loading = state is AuthLoading);

  //         if (state is AuthError) {
  //           ScaffoldMessenger.of(context)
  //               .showSnackBar(SnackBar(content: Text(state.message)));
  //         }
  //       },
  //       builder: (context, state) {
  //         return Center(
  //           child: Padding(
  //             padding: const EdgeInsets.all(20),
  //             child: Card(
  //               elevation: 4,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(16)),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(20),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Text(
  //                       "Welcome",
  //                       style: Theme.of(context).textTheme.headlineSmall,
  //                     ),
  //                     const SizedBox(height: 20),
  //                     TextField(
  //                       controller: emailCtrl,
  //                       decoration: const InputDecoration(
  //                         labelText: "Email",
  //                         border: OutlineInputBorder(),
  //                       ),
  //                     ),
  //                     const SizedBox(height: 15),
  //                     // TextField(
  //                     //   controller: passwordCtrl,
  //                     //   obscureText: true,
  //                     //   decoration: const InputDecoration(
  //                     //     labelText: "Password",
  //                     //     border: OutlineInputBorder(),
  //                     //   ),
  //                     // ),
  //                     TextField(
  //                       controller: passwordCtrl,
  //                       obscureText: obscurePassword,
  //                       decoration: InputDecoration(
  //                         labelText: "Password",
  //                         border: const OutlineInputBorder(),
  //                         suffixIcon: IconButton(
  //                           icon: Icon(
  //                             obscurePassword
  //                                 ? Icons.visibility_off
  //                                 : Icons.visibility,
  //                           ),
  //                           onPressed: () {
  //                             setState(() {
  //                               obscurePassword = !obscurePassword;
  //                             });
  //                           },
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(height: 25),
  //                     SizedBox(
  //                       width: double.infinity,
  //                       height: 45,
  //                       child: loading
  //                           ? const Center(child: CircularProgressIndicator())
  //                           : ElevatedButton(
  //                               // onPressed: () {
  //                               //   if (emailCtrl.text.isEmpty ||
  //                               //       passwordCtrl.text.isEmpty) {
  //                               //     showEmptyAlert();
  //                               //     return;
  //                               //   }

  //                               //   context.read<AuthBloc>().add(
  //                               //         LoginEvent(
  //                               //           emailCtrl.text,
  //                               //           passwordCtrl.text,
  //                               //         ),
  //                               //       );
  //                               // },
  //                               onPressed: () {
  //                                 if (emailCtrl.text.isEmpty ||
  //                                     passwordCtrl.text.isEmpty) {
  //                                   showAlert("Semua data wajib diisi");
  //                                   return;
  //                                 }

  //                                 if (!isValidEmail(emailCtrl.text)) {
  //                                   showAlert("Format email tidak valid");
  //                                   return;
  //                                 }

  //                                 context.read<AuthBloc>().add(
  //                                       LoginEvent(
  //                                         emailCtrl.text,
  //                                         passwordCtrl.text,
  //                                       ),
  //                                     );
  //                               },
  //                               child: const Text("Login"),
  //                             ),
  //                     ),
  //                     const SizedBox(height: 15),
  //                     TextButton(
  //                       onPressed: () {
  //                         Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (_) => const ForgotPasswordScreen()),
  //                         );
  //                       },
  //                       child: Expanded(
  //                         child: const Text(
  //                           "Forgot Password?",
  //                           style: TextStyle(
  //                             color: Colors.blue,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ),
  //                     ),

  //                     /// Text Login/Register
  //                     Expanded(
  //                       child: RichText(
  //                         text: TextSpan(
  //                           style: const TextStyle(fontSize: 14),
  //                           children: [
  //                             const TextSpan(
  //                               text: "Belum punya akun? ",
  //                               style: TextStyle(color: Colors.black),
  //                             ),
  //                             TextSpan(
  //                               text: "Register",
  //                               style: const TextStyle(
  //                                 color: Colors.blue,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                               recognizer: TapGestureRecognizer()
  //                                 ..onTap = () {
  //                                   Navigator.push(
  //                                     context,
  //                                     MaterialPageRoute(
  //                                         builder: (_) => const RegisterScreen()),
  //                                   );
  //                                 },
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: orangeThemeColor,
        foregroundColor: Colors.black,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          setState(() => loading = state is AuthLoading);

          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 64,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      "Welcome Back",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Silakan login untuk melanjutkan",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),

                    const SizedBox(height: 32),

                    /// EMAIL
                    TextField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        hintText: "contoh@email.com",
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// PASSWORD
                    TextField(
                      controller: passwordCtrl,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// LOGIN BUTTON
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: loading
                            ? null
                            : () {
                                if (emailCtrl.text.isEmpty ||
                                    passwordCtrl.text.isEmpty) {
                                  showAlert("Semua data wajib diisi");
                                  return;
                                }

                                if (!isValidEmail(emailCtrl.text)) {
                                  showAlert("Format email tidak valid");
                                  return;
                                }

                                context.read<AuthBloc>().add(
                                      LoginEvent(
                                        emailCtrl.text,
                                        passwordCtrl.text,
                                      ),
                                    );
                              },
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// FORGOT PASSWORD
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: const Text("Forgot Password?"),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// REGISTER
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 14),
                          children: [
                            const TextSpan(
                              text: "Belum punya akun? ",
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: "Register",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterScreen(),
                                    ),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
