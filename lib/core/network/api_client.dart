import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show SupabaseClient;

import 'auth_interceptor.dart';

/// Dio for our Supabase Edge Functions (offers, go).
/// Cuelinks is never called from the app: its key stays on the server.
class ApiClient {
  final Dio dio;

  /// [supabaseUrl] is the project address, e.g. https://abcd.supabase.co
  ApiClient(SupabaseClient supabase, {required String supabaseUrl})
      : dio = Dio(
          BaseOptions(
            baseUrl: '$supabaseUrl/functions/v1/',
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 30),
            contentType: Headers.jsonContentType,
          ),
        ) {
    dio.interceptors.add(AuthInterceptor(supabase: supabase, dio: dio));
  }

  Future<dynamic> get(String path) async {
    final response = await dio.get(path);
    return response.data;
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final response = await dio.post(path, data: body);
    return response.data;
  }
}
