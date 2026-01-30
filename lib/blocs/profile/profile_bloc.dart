import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../repositories/profile_repository.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repo;

  ProfileBloc(this.repo) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_loadProfile);
    on<UpdateProfileEvent>(_updateProfile);
    on<UpdateProfileImageEvent>(_updateProfileImage);
    on<UpdatePasswordEvent>(_updatePassword);
  }

  Future<void> _loadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString("auth_user");

      if (userJson == null) {
        emit(ProfileError("User not found"));
        return;
      }

      final user = jsonDecode(userJson);

      emit(ProfileLoaded(
        user["name"] ?? "",
        user["email"] ?? "",
        user["profile_image"],
      ));
    } catch (e) {
      emit(ProfileError("Failed to load profile"));
    }
  }

  Future<void> _updateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final res = await repo.updateProfile(event.name, event.email);

      await _saveUserToPrefs(res["body"]["user"]);

      emit(ProfileSuccess("Profile berhasil diperbarui"));
      emit(ProfileUpdated());
      add(LoadProfileEvent());
    } catch (e) {
      emit(ProfileError("Gagal update profile"));
    }
  }

  Future<void> _updateProfileImage(
    UpdateProfileImageEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final res = await repo.updateProfileImage(event.imagePath);

      final prefs = await SharedPreferences.getInstance();
      final user = jsonDecode(prefs.getString("auth_user")!);

      user["profile_image"] = res["profile_image_url"];

      await prefs.setString("auth_user", jsonEncode(user));

      emit(ProfileSuccess("Foto profil berhasil diperbarui"));
      add(LoadProfileEvent());
    } catch (e) {
      emit(ProfileError("Gagal upload foto"));
    }
  }

  Future<void> _updatePassword(
    UpdatePasswordEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      await repo.updatePassword(
        event.currentPassword,
        event.newPassword,
        event.confirmPassword,
      );

      emit(ProfileSuccess("Password berhasil diperbarui"));
    } catch (e) {
      emit(ProfileError("Password lama salah atau gagal update"));
    }
  }

  Future<void> _saveUserToPrefs(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_user", jsonEncode(user));
  }
}
