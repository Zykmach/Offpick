import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';

/// Stores sensitive values like the auth token in the keychain / keystore.
class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> readToken() async {
    try {
      return await storage.read(key: AppConstants.keyAuthToken);
    } catch (error) {
      return null;
    }
  }

  Future<void> saveToken(String token) {
    return storage.write(key: AppConstants.keyAuthToken, value: token);
  }

  Future<void> clearToken() {
    return storage.delete(key: AppConstants.keyAuthToken);
  }
}
