
import 'package:flutter/foundation.dart';

import '../../../core/services/storage/token_storage.dart';
import '../models/login_request.dart';
import '../models/user_role.dart';
import '../services/auth_service.dart';
import '../services/jwt_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final JwtService _jwtService = JwtService();
  final TokenStorage _tokenStorage = const TokenStorage();

  UserRole? _role;
  bool _isRestoring = true;

  UserRole? get role => _role;
  bool get isAuthenticated => _role != null;
  bool get isRestoring => _isRestoring;

  Future<UserRole> login(LoginRequest request) async {
    final response = await _authService.login(request);
    final role = _jwtService.extractRole(response.token);

    await _tokenStorage.saveToken(response.token);

    _role = role;
    notifyListeners();

    return role;
  }

  Future<void> restoreSession() async {
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
    }
  }

  Future<void> logout() async {
    await _tokenStorage.deleteToken();

    _role = null;
    notifyListeners();
  }
}
