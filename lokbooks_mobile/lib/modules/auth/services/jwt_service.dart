
import 'dart:convert';

import '../models/user_role.dart';

class JwtService {
  UserRole extractRole(String token) {
    final parts = token.split('.');

    if (parts.length != 3) {
      throw const FormatException('JWT inválido');
    }

    final payload = utf8.decode(
      base64Url.decode(
        base64Url.normalize(parts[1]),
      ),
    );

    final claims = jsonDecode(payload);

    if (claims is! Map<String, dynamic>) {
      throw const FormatException('Payload inválido');
    }

    final role = claims['role'];
    final expiration = claims['exp'];

    if (role is! String || expiration is! int) {
      throw const FormatException('Claims inválidas');
    }

    final currentTime =
        DateTime.now().millisecondsSinceEpoch ~/ 1000;

    if (expiration <= currentTime) {
      throw const FormatException('JWT expirado');
    }

    return UserRole.fromString(role);
  }
}
