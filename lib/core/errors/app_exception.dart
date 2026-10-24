/// A simple error that carries a message we can show to the user.
class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  factory AppException.from(Object error) {
    if (error is AppException) return error;
    return const AppException('Something went wrong. Please try again.');
  }

  @override
  String toString() => message;
}
