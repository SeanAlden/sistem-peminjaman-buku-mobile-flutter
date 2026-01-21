import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_peminjaman_buku_mobile_app/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;

  AuthBloc(this.repo) : super(AuthInitial()) {
    on<LoginEvent>(_login);
    on<RegisterEvent>(_register);
    on<CheckAuthTokenEvent>(_checkToken);
    on<LogoutEvent>(_logout);
    on<UpdateProfileEvent>(_updateProfile);
    on<UpdatePasswordEvent>(_updatePassword);
  }

  // Future<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
  //   emit(AuthLoading());

  //   final result = await repo.login(event.email, event.password);

  //   if (result["statusCode"] == 201) {
  //     String token = result["body"]["token"];

  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setString("auth_token", token);
  //     await prefs.setString("auth_user", jsonEncode(result["body"]["user"]));

  //     emit(AuthAuthenticated(token));
  //   } else {
  //     emit(AuthError(result["body"]["message"] ?? "Login gagal"));
  //   }
  // }

  Future<void> _login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await repo.login(event.email, event.password);
    final body = result["body"]; // <-- pindahkan ke sini

    if (result["statusCode"] == 201) {
      final token = body["token"];
      final user = body["user"];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("auth_token", token);
      await prefs.setString("auth_user", jsonEncode(user));

      repo.token = token;

      emit(AuthAuthenticated(token));
    } else {
      emit(AuthError(body["message"] ?? "Login gagal"));
    }
  }

  Future<void> _register(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await repo.register(
      event.name,
      event.email,
      event.phone,
      event.password,
      event.confirmPassword,
    );

    if (result["statusCode"] == 201) {
      String token = result["body"]["token"];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("auth_token", token);

      emit(AuthAuthenticated(token));
    } else {
      emit(AuthError(result["body"]["message"] ?? "Register gagal"));
    }
  }

  Future<void> _checkToken(
      CheckAuthTokenEvent event, Emitter<AuthState> emit) async {
    emit(AuthChecking());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");

    if (token != null && token.isNotEmpty) {
      emit(AuthAuthenticated(token));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("auth_token");
    emit(AuthUnauthenticated());
  }

  Future<void> _updateProfile(
    UpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final res = await repo.updateProfile(event.name, event.email);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("auth_user", jsonEncode(res['user']));

      emit(AuthProfileUpdated());
    } catch (e) {
      emit(AuthError("Gagal memperbarui profil"));
    }
  }

  Future<void> _updatePassword(
    UpdatePasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await repo.updatePassword(
        event.currentPassword,
        event.newPassword,
        event.confirmPassword,
      );

      emit(AuthPasswordUpdated());
    } catch (e) {
      emit(AuthError("Password lama salah atau gagal update"));
    }
  }
}
