import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Session, SupabaseClient;

import '../constants/env_config.dart';

/// Adds the logged-in user's token (from Google sign-in) to every request.
/// If the token has run out, it gets a fresh one and tries the request once more.
class AuthInterceptor extends QueuedInterceptor {
  final SupabaseClient supabase;
  final Dio dio;

  AuthInterceptor({required this.supabase, required this.dio});

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    var session = supabase.auth.currentSession;
    if (session != null && session.isExpired) {
      session = await refresh();
    }
    options.headers['apikey'] = EnvConfig.supabaseKey;
    if (session != null) options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final isUnauthorised = err.response?.statusCode == 401;
    final alreadyRetried = options.extra['retried'] == true;
    if (!isUnauthorised || alreadyRetried) return handler.next(err);

    final session = await refresh();
    if (session == null) return handler.next(err);

    options.extra['retried'] = true;
    options.headers['Authorization'] = 'Bearer ${session.accessToken}';
    try {
      handler.resolve(await dio.fetch(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<Session?> refresh() async {
    try {
      final response = await supabase.auth.refreshSession();
      return response.session;
    } catch (error) {
      return null;
    }
  }
}
