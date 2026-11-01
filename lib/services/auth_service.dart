import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/constants/env_config.dart';
import '../core/errors/app_exception.dart';

/// Google sign-in on the phone, then the Google ID token is exchanged for
/// a Supabase session. Supabase keeps and refreshes the session itself.
class AuthService {
  final SupabaseClient client;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  bool isGoogleReady = false;

  AuthService(this.client);

  bool get hasSession => client.auth.currentSession != null;

  Future<void> prepareGoogle() async {
    if (isGoogleReady) return;
    if (EnvConfig.googleWebClientId.isEmpty) {
      throw const AppException('Google sign-in is not set up yet. Add GOOGLE_WEB_CLIENT_ID to env.json.');
    }
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;
    await googleSignIn.initialize(
      serverClientId: EnvConfig.googleWebClientId,
      clientId: isIos && EnvConfig.googleIosClientId.isNotEmpty ? EnvConfig.googleIosClientId : null,
    );
    isGoogleReady = true;
  }

  Future<void> signInWithGoogle() async {
    await prepareGoogle();
    final GoogleSignInAccount account;
    try {
      account = await googleSignIn.authenticate(scopeHint: const ['email', 'profile']);
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw const AppException('Sign-in was cancelled');
      }
      throw AppException(error.description ?? 'Google sign-in failed. Please try again.');
    }

    final idToken = account.authentication.idToken;
    if (idToken == null) throw const AppException('Google did not return a sign-in token.');
    await client.auth.signInWithIdToken(provider: OAuthProvider.google, idToken: idToken);
  }

  Future<void> signOut() async {
    await client.auth.signOut();
    if (isGoogleReady) await googleSignIn.signOut();
  }
}
