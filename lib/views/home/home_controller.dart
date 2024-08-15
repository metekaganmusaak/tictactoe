import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oxidized/oxidized.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tictactoe/services/remote/auth_service.dart';
import 'package:tictactoe/services/remote/database_service.dart';

class HomeController extends GetxController {
  RxBool showEnterNamePopup = false.obs;

  late final TextEditingController nameController;

  late final RealtimeChannel roomsSubscription;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    final username = Get.find<AuthService>().currentUser?.userMetadata?['name'];

    if (username == null) {
      showEnterNamePopup.value = true;
    }
  }

  @override
  void onClose() {
    nameController.dispose();

    super.onClose();
  }

  Future<Result<bool, String>> saveUsername() async {
    try {
      final result =
          await Get.find<AuthService>().saveUsername(name: nameController.text);

      if (result.isErr()) {
        final error = result.unwrapErr();

        /// You can modify error here.
        return Err(error);
      }

      showEnterNamePopup.value = false;
      return const Ok(true);
    } catch (e) {
      return Err(e.toString());
    }
  }

  SupabaseStreamBuilder fetchAllRooms() {
    return Get.find<DatabaseService>().fetchAllRooms();
  }

  String get currentUsername => Get.find<AuthService>().getUsername() ?? '';

  Future<void> updateRoomParticipant(String roomId) async {
    await Get.find<DatabaseService>().updateRoomParticipant(
      roomId,
      username: currentUsername,
    );
  }
}
