class ApiConstants {
  static const String baseUrl = 'https://api.offpick.app/v1';
  static const Duration timeout = Duration(seconds: 20);

  /// When true, the ApiClient answers from the local mock server
  /// instead of calling [baseUrl]. Turn off once the backend is live.
  static const bool useMockServer = true;

  /// Fake network delay so loaders and animations can be seen.
  static const Duration mockLatency = Duration(milliseconds: 650);
}
