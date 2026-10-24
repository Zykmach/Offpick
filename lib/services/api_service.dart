import '../core/errors/app_exception.dart';
import '../core/network/api_client.dart';

/// Typed helpers on top of ApiClient so repositories get clean JSON back.
class ApiService {
  final ApiClient client;

  ApiService(this.client);

  Future<List<Map<String, dynamic>>> getList(String path, {Map<String, String>? query}) async {
    try {
      final data = await client.get(path, query: query);
      return (data as List).cast<Map<String, dynamic>>();
    } catch (error) {
      throw AppException.from(error);
    }
  }

  Future<Map<String, dynamic>> getMap(String path, {Map<String, String>? query}) async {
    try {
      final data = await client.get(path, query: query);
      return data as Map<String, dynamic>;
    } catch (error) {
      throw AppException.from(error);
    }
  }

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? body}) async {
    try {
      final data = await client.post(path, body: body);
      return data as Map<String, dynamic>;
    } catch (error) {
      throw AppException.from(error);
    }
  }

  void setToken(String? token) => client.authToken = token;
}
