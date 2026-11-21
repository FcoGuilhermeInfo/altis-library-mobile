
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/services/http/api_client.dart';
import '../../../core/services/storage/token_storage.dart';
import '../models/admin_dashboard_model.dart';
import '../models/user_dashboard_model.dart';

class DashboardRequestException implements Exception {
  final int? statusCode;

  const DashboardRequestException({
    this.statusCode,
  });
}

class DashboardService {
  final TokenStorage _tokenStorage = const TokenStorage();

  Future<Map<String, dynamic>> _getDashboard(
    String endpoint,
  ) async {
    final token = await _tokenStorage.getToken();

    if (token == null || token.isEmpty) {
      throw const DashboardRequestException(
        statusCode: 401,
      );
    }

    try {
      final response = await ApiClient.client
          .get(
            ApiClient.buildUri(endpoint),
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw DashboardRequestException(
          statusCode: response.statusCode,
        );
      }

      final decoded = jsonDecode(
        utf8.decode(response.bodyBytes),
      );

      if (decoded is! Map<String, dynamic>) {
        throw const DashboardRequestException();
      }

      return decoded;
    } on SocketException {
      throw const DashboardRequestException();
    } on TimeoutException {
      throw const DashboardRequestException();
    } on http.ClientException {
      throw const DashboardRequestException();
    } on FormatException {
      throw const DashboardRequestException();
    }
  }

  Future<AdminDashboardModel> getAdminDashboard() async {
    final response = await _getDashboard('/dashboard/admin');

    return AdminDashboardModel.fromJson(response);
  }

  Future<UserDashboardModel> getUserDashboard() async {
    final response = await _getDashboard('/dashboard/user');

    return UserDashboardModel.fromJson(response);
  }
}
