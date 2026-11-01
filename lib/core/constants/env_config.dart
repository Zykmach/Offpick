/// Keys passed at build time with `--dart-define-from-file=env.json`.
/// See env.example.json in the project root.
class EnvConfig {
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  /// "Publishable key" from Project Settings > API Keys (the older "anon" key also works).
  /// Safe to ship in the app: row level security decides what it can read.
  static const String supabaseKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  /// The "Web application" OAuth client from Google Cloud. Supabase checks
  /// the Google ID token against it, on Android and iOS alike.
  static const String googleWebClientId = String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');

  /// The "iOS" OAuth client from Google Cloud. Not needed on Android.
  static const String googleIosClientId = String.fromEnvironment('GOOGLE_IOS_CLIENT_ID');

  static bool get hasSupabase => supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty;
}
