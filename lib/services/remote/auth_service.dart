import 'dart:developer';

import 'package:get/get.dart';
import 'package:oxidized/oxidized.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthService {
  Future<AuthService> init();
  Future<Result<bool, String>> signOut();
  Future<Result<bool, String>> saveUsername({required String name});
}

class AuthService extends GetxService implements IAuthService {
  final SupabaseClient client = Supabase.instance.client;
  late final User? currentUser;

  @override
  Future<AuthService> init() async {
    try {
      if (client.auth.currentUser == null) {
        await client.auth.signInAnonymously();
        currentUser = client.auth.currentUser;
        return this;
      }

      currentUser = client.auth.currentUser;
      return this;
    } catch (e) {
      log(e.toString(), name: 'AuthService.init()');
      return this;
    }
  }

  @override
  Future<Result<bool, String>> signOut() async {
    try {
      await client.auth.signOut();
      return const Ok(true);
    } catch (e) {
      return Err(e.toString());
    }
  }

  @override
  Future<Result<bool, String>> saveUsername({required String name}) async {
    try {
      await client.auth.updateUser(
        UserAttributes(data: {
          'name': name,
        }),
      );

      return const Ok(true);
    } catch (e) {
      return Err(e.toString());
    }
  }
}
