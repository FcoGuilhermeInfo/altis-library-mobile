
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/services/http/api_client.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthService {
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await ApiClient.client
          .post(
            ApiClient.buildUri('/auth/login'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 401) {
        throw const AuthException(
          AuthError.invalidCredentials,
        );
      }

      if (response.statusCode != 200) {
        throw const AuthException(
          AuthError.serverError,
        );
      }

      final json = jsonDecode(response.body)
          as Map<String, dynamic>;

      return LoginResponse.fromJson(json);
    } on AuthException {
      rethrow;
    } on SocketException {
      throw const AuthException(
        AuthError.connectionError,
      );
    } on HttpException {
      throw const AuthException(
        AuthError.connectionError,
      );
    } on http.ClientException {
      throw const AuthException(
        AuthError.connectionError,
      );
    } on FormatException {
      throw const AuthException(
        AuthError.serverError,
      );
    } catch (error) {
      if (error is Error) rethrow;

      throw const AuthException(
        AuthError.serverError,
      );
    }
  }
}

enum AuthError {
  invalidCredentials,
  connectionError,
  serverError,
}

class AuthException implements Exception {
  final AuthError error;

  const AuthException(this.error);
}
