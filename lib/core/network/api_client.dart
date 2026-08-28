import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_app/utils/api_exception.dart';

import 'api_endpoints.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiEndpoints.baseUrl}$endpoint',
      ).replace(
        queryParameters: queryParameters,
      );

      final response = await _client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }

      throw ApiException(
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<dynamic> post(
    String endpoint, {
    dynamic body,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiEndpoints.baseUrl}$endpoint',
      );

      final response = await _client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }

      throw ApiException(
        message: 'Something went wrong. Please try again.',
      );
    }
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    dynamic data;

    if (response.body.isNotEmpty) {
      data = jsonDecode(response.body);
    }

    if (statusCode >= 200 && statusCode < 300) {
      return data;
    }

    throw ApiException(
      message: data is Map && data['message'] != null
          ? data['message']
          : 'Request failed',
      statusCode: statusCode,
    );
  }
}
