import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;

  RegisterEvent(this.name, this.email, this.phone, this.password, this.confirmPassword);
}

class CheckAuthTokenEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

