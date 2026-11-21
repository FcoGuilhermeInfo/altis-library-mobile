
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/services/http/api_client.dart';
import '../../../core/services/storage/token_storage.dart';
import '../models/profile_model.dart';

class ProfileRequestException implements Exception {
  final int? statusCode;

  const ProfileRequestException({this.statusCode});
}

class ProfileService {
  final TokenStorage _tokenStorage = const TokenStorage();

  String _extractUserId(String token) {
    try {
      final parts = token.split('.');

      if (parts.length != 3) {
        throw const FormatException();
      }

      final payload = utf8.decode(
        base64Url.decode(
          base64Url.normalize(parts[1]),
        ),
      );

      final claims = jsonDecode(payload)
          as Map<String, dynamic>;

      final userId = claims['userId'];

      if (userId is! String || userId.isEmpty) {
        throw const FormatException();
      }

      return userId;
    } catch (_) {
      throw const ProfileRequestException(
        statusCode: 401,
      );
    }
  }

  Future<String> _getToken() async {
    final token = await _tokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw const ProfileRequestException(
        statusCode: 401,
      );
    }

    return token;
  }

  Future<http.Response> _request(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final token = await _getToken();

    final request = http.Request(
      method,
      ApiClient.buildUri(endpoint),
    );

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    });

    if (body != null) {
      request.body = jsonEncode(body);
    }

    try {
      final streamedResponse = await ApiClient.client
          .send(request)
          .timeout(const Duration(seconds: 15));

      final response = await http.Response.fromStream(
        streamedResponse,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode < 200 ||
          response.statusCode >= 300) {
        throw ProfileRequestException(
          statusCode: response.statusCode,
        );
      }

      return response;
    } on SocketException {
      throw const ProfileRequestException();
    } on TimeoutException {
      throw const ProfileRequestException();
    } on http.ClientException {
      throw const ProfileRequestException();
    }
  }

  ProfileModel _parseProfile(http.Response response) {
    try {
      final data = jsonDecode(
        utf8.decode(response.bodyBytes),
      ) as Map<String, dynamic>;

      return ProfileModel.fromJson(data);
    } catch (_) {
      throw const ProfileRequestException();
    }
  }

  Future<ProfileModel> getMyProfile() async {
    final token = await _getToken();
    final userId = _extractUserId(token);

    final response = await _request(
      'GET',
      '/users/$userId',
    );

    return _parseProfile(response);
  }

  Future<ProfileModel> updateMyProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    final token = await _getToken();
    final userId = _extractUserId(token);

    final response = await _request(
      'PATCH',
      '/users/$userId',
      body: {
        'name': name.trim(),
        'phone': phone.replaceAll(RegExp(r'\D'), ''),
        'address': address.trim(),
      },
    );

    return _parseProfile(response);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _request(
      'PATCH',
      '/users/me/password',
      body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );
  }
}
