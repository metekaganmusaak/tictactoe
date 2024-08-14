import 'package:get/get.dart';
import 'package:oxidized/oxidized.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tictactoe/models/room_model.dart';
import 'package:tictactoe/services/remote/database_service.dart';

enum GameMoveTurn {
  player1,
  player2,
}

class GameController extends GetxController {
  final room = Get.arguments as RoomModel;

  Rx<GameMoveTurn> turn = GameMoveTurn.player1.obs;

  SupabaseStreamBuilder gameStream() {
    return Get.find<DatabaseService>().listenRoomById(room.id);
  }

  String userFirstLetters(String name) {
    return name.split(' ').map((e) => e[0].toUpperCase()).join('');
  }

  Future<void> makeMove(int index) async {
    var moves = await Get.find<DatabaseService>().getMoves(room.id);

    if (moves[index] != '') return;

    moves[index] = turn.value == GameMoveTurn.player1 ? 'X' : 'O';

    await Get.find<DatabaseService>()
        .updateMovesByRoomId(room.id, moves as List<String>);

    turn.value = turn.value == GameMoveTurn.player1
        ? GameMoveTurn.player2
        : GameMoveTurn.player1;
  }

  Future<Result<bool, String>> finishGame() async {
    try {
      await Get.find<DatabaseService>().finishGame(room.id);

      return const Ok(true);
    } catch (e) {
      return Err(e.toString());
    }
  }
}
