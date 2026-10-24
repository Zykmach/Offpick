import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../services/mock/mock_server.dart';
import '../constants/api_constants.dart';
import '../errors/app_exception.dart';

/// Every network call in the app goes through this class.
/// While the backend is not ready, requests are answered by [MockServer].
class ApiClient {
  final MockServer mockServer;
  String? authToken;

  ApiClient({required this.mockServer, this.authToken});

  Future<dynamic> get(String path, {Map<String, String>? query}) {
    return send('GET', path, query: query);
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) {
    return send('POST', path, body: body);
  }

  Future<dynamic> send(
    String method,
    String path, {
    Map<String, String>? query,
    Map<String, dynamic>? body,
  }) async {
    if (ApiConstants.useMockServer) {
      await Future.delayed(ApiConstants.mockLatency);
      return mockServer.handle(method, path, query: query ?? {}, body: body ?? {});
    }
    return sendReal(method, path, query: query, body: body);
  }

  Future<dynamic> sendReal(
    String method,
    String path, {
    Map<String, String>? query,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$path').replace(queryParameters: query);
    final headers = {
      'Content-Type': 'application/json',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };

    try {
      final response = method == 'GET'
          ? await http.get(uri, headers: headers).timeout(ApiConstants.timeout)
          : await http
              .post(uri, headers: headers, body: jsonEncode(body ?? {}))
              .timeout(ApiConstants.timeout);

      final data = response.body.isEmpty ? null : jsonDecode(response.body);
      if (response.statusCode >= 400) {
        final message = data is Map ? data['message']?.toString() : null;
        throw AppException(message ?? 'Request failed', statusCode: response.statusCode);
      }
      return data;
    } on AppException {
      rethrow;
    } catch (error) {
      throw const AppException('Could not reach the server. Check your internet.');
    }
  }
}
