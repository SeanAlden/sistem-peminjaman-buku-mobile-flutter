import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String email;
  final String? profileImage;
  ProfileLoaded(this.name, this.email, this.profileImage);
}

class ProfileUpdated extends ProfileState {}

class PasswordUpdated extends ProfileState {}

class ProfileImageUpdated extends ProfileState {
  final String imageUrl;
  ProfileImageUpdated(this.imageUrl);
}

class ProfileImageUploading extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
