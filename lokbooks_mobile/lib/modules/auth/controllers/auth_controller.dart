
import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../core/services/storage/token_storage.dart';
import '../../profile/models/profile_model.dart';
import '../../profile/services/profile_service.dart';
import '../models/login_request.dart';
import '../models/user_role.dart';
import '../services/auth_service.dart';
import '../services/jwt_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final JwtService _jwtService = JwtService();
  final ProfileService _profileService = ProfileService();
  final TokenStorage _tokenStorage = const TokenStorage();

  UserRole? _role;
  ProfileModel? _profile;
  bool _isRestoring = true;
  bool _isLoadingProfile = false;
  int _sessionVersion = 0;

  UserRole? get role => _role;
  ProfileModel? get profile => _profile;
  String? get userName => _profile?.name;
  bool get isAuthenticated => _role != null;
  bool get isRestoring => _isRestoring;
  bool get isLoadingProfile => _isLoadingProfile;

  Future<UserRole> login(LoginRequest request) async {
    final response = await _authService.login(request);
    final role = _jwtService.extractRole(response.token);

    await _tokenStorage.saveToken(response.token);

    _sessionVersion++;
    _role = role;
    _profile = null;
    _isLoadingProfile = false;

    notifyListeners();

    unawaited(refreshProfile());

    return role;
  }

  Future<void> restoreSession() async {
    _sessionVersion++;
    _profile = null;
    _role = null;

    try {
      final token = await _tokenStorage.getToken();

      if (token != null) {
        try {
          _role = _jwtService.extractRole(token);
        } on FormatException {
          await _tokenStorage.deleteToken();
          _role = null;
        }
      }
    } catch (_) {
      _role = null;
    } finally {
      _isRestoring = false;
      notifyListeners();

      if (_role != null) {
        unawaited(refreshProfile());
      }
    }
  }

  Future<void> refreshProfile() async {
    if (!isAuthenticated) {
      return;
    }

    final version = _sessionVersion;

    _isLoadingProfile = true;
    notifyListeners();

    try {
      final loadedProfile = await _profileService.getMyProfile();

      if (version != _sessionVersion || !isAuthenticated) {
        return;
      }

      _profile = loadedProfile;
      notifyListeners();
    } catch (_) {
      if (version != _sessionVersion || !isAuthenticated) {
        return;
      }
    } finally {
      if (version == _sessionVersion) {
        _isLoadingProfile = false;
        notifyListeners();
      }
    }
  }

  void updateProfile(ProfileModel updatedProfile) {
    if (!isAuthenticated) {
      return;
    }

    if (_profile != null &&
        _profile!.id != updatedProfile.id) {
      return;
    }

    _profile = updatedProfile;
    notifyListeners();
  }

  Future<void> logout() async {
    _sessionVersion++;

    await _tokenStorage.deleteToken();

    _role = null;
    _profile = null;
    _isLoadingProfile = false;

    notifyListeners();
  }
}
