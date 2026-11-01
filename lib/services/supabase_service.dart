import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin wrapper over the Supabase client that the repositories share.
class SupabaseService {
  final SupabaseClient client;

  SupabaseService(this.client);

  String? get userId => client.auth.currentUser?.id;

  bool get isLoggedIn => userId != null;

  /// Reads a whole view, optionally sorted by one column.
  Future<List<Map<String, dynamic>>> readAll(String view, {String? orderBy, bool ascending = true}) {
    final query = client.from(view).select();
    if (orderBy == null) return query;
    return query.order(orderBy, ascending: ascending);
  }

  /// Sends a change to the server without making the user wait on it.
  /// The app already saved its local copy, and every write sends the
  /// full list, so the next change also fixes one that failed.
  Future<void> push(Future<void> Function(SupabaseClient client) action) async {
    if (!isLoggedIn) return;
    try {
      await action(client);
    } catch (error) {
      debugPrint('Supabase sync failed: $error');
    }
  }
}
