import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  static Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
  }
}
