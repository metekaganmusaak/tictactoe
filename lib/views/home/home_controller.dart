import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oxidized/oxidized.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tictactoe/services/remote/auth_service.dart';
import 'package:tictactoe/services/remote/database_service.dart';

class HomeController extends GetxController {
  late final TextEditingController? nameController;
  late final RealtimeChannel roomsSubscription;

  RxBool showEnterName = false.obs;

  String get currentUsername => Get.find<AuthService>().getUsername() ?? '';

  @override
  void onInit() {
    super.onInit();
    // If user doesn't have a username, show enter name view.
    if (currentUsername.isEmpty) {
      nameController = TextEditingController();
      showEnterName.value = true;
    }
  }

  @override
  void onClose() {
    nameController?.dispose();
    super.onClose();
  }

  Future<Result<bool, String>> saveUsername() async {
    try {
      final username = nameController?.text;

      if (username == null) {
        return const Err('Something went wrong!');
      }

      if (username.isEmpty) {
        return const Err('Username can not be empty.');
      }

      final result = await Get.find<AuthService>()
          .saveUsername(name: nameController!.text);

      if (result.isErr()) {
        final error = result.unwrapErr();

        /// You can modify error here.
        return Err(error);
      }

      showEnterName.value = false;
      return const Ok(true);
    } catch (e) {
      return Err(e.toString());
    }
  }

  SupabaseStreamBuilder fetchAllRooms() {
    final streamResult = Get.find<DatabaseService>().fetchAllRooms();

    if (streamResult.isErr()) {
      // Handle error
    }

    return streamResult.unwrap();
  }

  Future<void> updateRoomParticipant(String roomId) async {
    await Get.find<DatabaseService>().updateRoomParticipant(
      roomId,
      username: currentUsername,
    );
  }
}
