import 'dart:developer';

import 'package:get/get.dart';
import 'package:oxidized/oxidized.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthService {
  Future<AuthService> init();
  Future<Result<bool, String>> signOut();
  Future<Result<bool, String>> saveUsername({required String name});
  String? getUsername();
}

class AuthService extends GetxService implements IAuthService {
  final SupabaseClient _client = Supabase.instance.client;
  User? get currentUser => _client.auth.currentUser;

  @override
  Future<AuthService> init() async {
    try {
      if (_client.auth.currentUser == null) {
        await _client.auth.signInAnonymously();
        return this;
      }

      return this;
    } catch (e) {
      log(e.toString(), name: 'AuthService.init()');
      return this;
    }
  }

  @override
  Future<Result<bool, String>> signOut() async {
    try {
      await _client.auth.signOut();
      return const Ok(true);
    } catch (e) {
      return Err(e.toString());
    }
  }

  @override
  Future<Result<bool, String>> saveUsername({required String name}) async {
    try {
      await _client.auth.updateUser(
        UserAttributes(data: {
          'name': name,
        }),
      );

      return const Ok(true);
    } catch (e) {
      return Err(e.toString());
    }
  }

  @override
  String? getUsername() {
    try {
      final username = currentUser?.userMetadata?['name'] as String?;
      if (username == null) {
        return null;
      }
      return username;
    } catch (e) {
      return null;
    }
  }
}
