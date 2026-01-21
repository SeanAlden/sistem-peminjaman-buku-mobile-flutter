// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import '../blocs/auth/auth_bloc.dart';
// // import '../blocs/auth/auth_event.dart';
// // import '../blocs/auth/auth_state.dart';
// // import 'login_screen.dart';
// // import '../main.dart';

// // class SplashScreen extends StatelessWidget {
// //   const SplashScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     context.read<AuthBloc>().add(CheckAuthTokenEvent());

// //     return Scaffold(
// //       body: Center(
// //         child: BlocConsumer<AuthBloc, AuthState>(
// //           listener: (context, state) {
// //             if (state is AuthAuthenticated) {
// //               Navigator.pushReplacement(
// //                 context,
// //                 MaterialPageRoute(builder: (_) => const MainTabs()),
// //               );
// //             } else if (state is AuthUnauthenticated) {
// //               Navigator.pushReplacement(
// //                 context,
// //                 MaterialPageRoute(builder: (_) => const LoginScreen()),
// //               );
// //             }
// //           },
// //           builder: (context, state) {
// //             return const CircularProgressIndicator();
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/auth/auth_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/auth/auth_event.dart';
import 'package:sistem_peminjaman_buku_mobile_app/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckAuthTokenEvent());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // body: Center(child: CircularProgressIndicator()),
      body: MainTabs(),
    );
  }
}
