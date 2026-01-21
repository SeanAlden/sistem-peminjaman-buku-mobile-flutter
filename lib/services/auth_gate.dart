import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/auth/auth_bloc.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/auth/auth_event.dart';
import 'package:sistem_peminjaman_buku_mobile_app/blocs/auth/auth_state.dart';
import 'package:sistem_peminjaman_buku_mobile_app/main.dart';
import 'package:sistem_peminjaman_buku_mobile_app/screens/login_screen.dart';

// class AuthGate extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthBloc, AuthState>(
//       builder: (context, state) {
//         if (state is AuthAuthenticated) return MainTabs();
//         return LoginScreen();
//       },
//     );
//   }
// }

// class AuthGate extends StatelessWidget {
//   const AuthGate({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthBloc, AuthState>(
//       builder: (context, state) {
//         if (state is AuthAuthenticated) {
//           return const MainTabs();
//         }
//         return const LoginScreen();
//       },
//     );
//   }
// }

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckAuthTokenEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const MainTabs();
        }

        if (state is AuthChecking) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return const LoginScreen();
      },
    );
  }
}


