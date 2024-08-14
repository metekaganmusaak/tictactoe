import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tictactoe/models/room_model.dart';
import 'package:tictactoe/services/remote/auth_service.dart';
import 'package:tictactoe/services/remote/database_service.dart';

class CreateGameController extends GetxController {
  Rx<BackgroundColor> selectedColor = BackgroundColor.values.first.obs;
  var selectedLevelIndex = 0.obs;
  var errorText = ''.obs;

  late final TextEditingController roomNameController;

  @override
  void onInit() {
    super.onInit();
    roomNameController = TextEditingController();
  }

  @override
  void onClose() {
    roomNameController.dispose();
    super.onClose();
  }

  Future<bool> createRoom() async {
    try {
      if (roomNameController.text.isEmpty) {
        errorText.value = 'Room name can not be empty.';
        return false;
      }
      errorText.value = '';

      final squares = List.filled(
        GameLevel.values[selectedLevelIndex.value].boardSize *
            GameLevel.values[selectedLevelIndex.value].boardSize,
        " ",
      );

      final room = RoomModel(
        id: '',
        title: roomNameController.text,
        backgroundColor: selectedColor.value.index,
        level: GameLevel.values[selectedLevelIndex.value].index,
        isFinished: false,
        player1Name: Get.find<AuthService>().currentUser?.userMetadata?['name'],
        player2Name: null,
        winnerName: null,
        moves: squares,
      );

      await Get.find<DatabaseService>().createRoom(room);

      return true;
    } catch (e) {
      errorText.value = e.toString();
      return false;
    }
  }
}
