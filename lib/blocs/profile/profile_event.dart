import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {}

class UpdatePasswordEvent extends ProfileEvent {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  UpdatePasswordEvent(
    this.currentPassword,
    this.newPassword,
    this.confirmPassword,
  );
}

class UpdateProfileEvent extends ProfileEvent {
  final String name;
  final String email;

  UpdateProfileEvent(this.name, this.email);
}

class UpdateProfileImageEvent extends ProfileEvent {
  final String imagePath;

  UpdateProfileImageEvent(this.imagePath);
}
