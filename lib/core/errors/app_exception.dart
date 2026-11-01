import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A simple error that carries a message we can show to the user.
class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  factory AppException.from(Object error) {
    if (error is AppException) return error;
    if (error is AuthException) return AppException(error.message);
    if (error is DioException) {
      final data = error.response?.data;
      final message = data is Map ? data['message'] as String? : null;
      if (message != null) return AppException(message, statusCode: error.response?.statusCode);
      return const AppException('Could not reach the server. Check your internet and try again.');
    }
    if (error is PostgrestException) {
      return const AppException('Could not load data from the server. Please try again.');
    }
    return const AppException('Something went wrong. Check your internet and try again.');
  }

  @override
  String toString() => message;
}
