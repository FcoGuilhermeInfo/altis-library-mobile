
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/services/http/api_client.dart';
import '../models/register_request.dart';

enum RegisterError {
  invalidData,
  forbidden,
  conflict,
  connection,
  server,
}

class RegisterException implements Exception {
  final RegisterError error;

  const RegisterException(this.error);
}

class RegisterService {
  Future<void> register(RegisterRequest request) async {
    http.Response response;

    try {
      response = await ApiClient.client
          .post(
            ApiClient.buildUri('/users'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 10));
    } on SocketException {
      throw const RegisterException(RegisterError.connection);
    } on http.ClientException {
      throw const RegisterException(RegisterError.connection);
    } on TimeoutException {
      throw const RegisterException(RegisterError.connection);
    }

    switch (response.statusCode) {
      case 201:
        return;
      case 400:
      case 422:
        throw const RegisterException(RegisterError.invalidData);
      case 401:
      case 403:
        throw const RegisterException(RegisterError.forbidden);
      case 409:
        throw const RegisterException(RegisterError.conflict);
      default:
        throw const RegisterException(RegisterError.server);
    }
  }
}
