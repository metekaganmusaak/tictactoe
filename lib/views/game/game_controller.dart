import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tictactoe/models/room_model.dart';
import 'package:tictactoe/services/remote/auth_service.dart';
import 'package:tictactoe/services/remote/database_service.dart';

enum GameMoveTurn {
  player1,
  player2,
}

class GameController extends GetxController {
  final room = Get.arguments as RoomModel;

  Rx<GameMoveTurn> turn = GameMoveTurn.player1.obs;
  RxnString winnerName = RxnString(null);
  RxBool isGameFinished = false.obs;

  StreamSubscription? roomChangesSubscription;

  final _audioPlayer = AudioPlayer();

  @override
  onInit() {
    super.onInit();
    listenGameChanges();
  }

  @override
  void onClose() {
    roomChangesSubscription?.cancel();
    super.onClose();
  }

  Future<void> listenGameChanges() async {
    final subscriptionResult =
        Get.find<DatabaseService>().listenRoomChanges(room.id);

    if (subscriptionResult.isErr()) {
      final error = subscriptionResult.unwrapErr();
      log('Error while listening game changes: $error');
      return;
    }

    final subscription = subscriptionResult.unwrap();

    roomChangesSubscription = subscription.listen(
      (data) async {
        if (data.isEmpty) return;

        turn.value = GameMoveTurn.values[data.first['current_move'] ?? 0];
        winnerName.value = data.first['winner_name'];
        isGameFinished.value = data.first['is_finished'] ?? false;

        if ((winnerName.value == 'X' || winnerName.value == 'O') &&
            isGameFinished.value) {
          _audioPlayer.play(AssetSource('sound_fx/win.mp3'));
          await deleteGameRoom();
          Get.back();
          return;
        }

        if ((isGameFinished.value == false && winnerName.value == 'D') &&
            !isGameFinished.value) {
          _audioPlayer.play(AssetSource('sound_fx/draw.mp3'));
          await restartGame();
          return;
        }

        if (winnerName.value == null) {
          return;
        }
      },
      onError: (error) {},
    );
  }

  Future<void> deleteGameRoom() async {
    await const Duration(seconds: 3).delay();
    await Get.find<DatabaseService>().deleteRoom(room.id);
  }

  Future<void> restartGame() async {
    await const Duration(seconds: 3).delay();

    /// Clear board
    await Get.find<DatabaseService>().updateMovesByRoomId(
        room.id,
        List.filled(
          GameLevel.values[room.level].boardSize *
              GameLevel.values[room.level].boardSize,
          " ",
          growable: false,
        ));

    /// Reset current move
    await Get.find<DatabaseService>().updateCurrentMoveByRoomId(
      room.id,
      currentMove: 0,
    );

    /// Reset winner name
    await _updateWinnerName(room.id, null);
  }

  bool get isPlayer1 =>
      room.player1Name == Get.find<AuthService>().getUsername();

  SupabaseStreamBuilder gameStream() {
    final subscriptionResult =
        Get.find<DatabaseService>().listenRoomChanges(room.id);

    if (subscriptionResult.isErr()) {}

    return subscriptionResult.unwrap();
  }

  String userFirstLetters(String name) {
    return name.split(' ').map((e) => e[0].toUpperCase()).join('');
  }

  Future<void> makeMove(int index) async {
    final boardSize = GameLevel.values[room.level].boardSize;
    var moves = await _getMoves();

    if (!_isValidMove(moves, index)) return;
    if (!_isPlayerTurn()) return;

    await _updateMove(moves, index);
    await _updateCurrentMove();

    final result = checkWinner(moves, boardSize);

    /// Game is still continue or never started.
    if (result == null) {
      return;
    }

    if (result == 'X' || result == 'O') {
      await _updateWinnerName(room.id, result);
      await Get.find<DatabaseService>().updateIsFinished(room.id, true);

      return;
    }

    if (result == 'D') {
      await _updateWinnerName(room.id, 'D');
      await Get.find<DatabaseService>().updateIsFinished(room.id, false);
      return;
    }
  }

  Future<void> _updateWinnerName(
    String roomId,
    String? winner,
  ) async {
    await Get.find<DatabaseService>().updateWinnerName(room.id, winner);
  }

  Future<List<dynamic>> _getMoves() async {
    final movesResult = await Get.find<DatabaseService>().getMoves(room.id);

    if (movesResult.isErr()) {
      return [];
    }

    final moves = movesResult.unwrap();

    return moves.first['moves'] as List<dynamic>;
  }

  bool _isValidMove(List<dynamic> moves, int index) {
    return moves[index] != 'X' && moves[index] != 'O';
  }

  bool _isPlayerTurn() {
    return !(isPlayer1 && turn.value == GameMoveTurn.player2 ||
        !isPlayer1 && turn.value == GameMoveTurn.player1);
  }

  Future<void> _updateMove(List<dynamic> moves, int index) async {
    turn.value == GameMoveTurn.player1
        ? _audioPlayer.play(AssetSource('sound_fx/player_x.mp3'))
        : _audioPlayer.play(AssetSource('sound_fx/player_o.mp3'));

    moves[index] = turn.value == GameMoveTurn.player1 ? 'X' : 'O';

    await Get.find<DatabaseService>().updateMovesByRoomId(room.id, moves);
  }

  Future<void> _updateCurrentMove() async {
    await Get.find<DatabaseService>().updateCurrentMoveByRoomId(
      room.id,
      currentMove: turn.value == GameMoveTurn.player1 ? 1 : 0,
    );
  }

  String? checkWinner(List<dynamic> moves, int size) {
    List<List<String>> board = _createBoard(moves, size);

    String? winner = _checkLines(board, size);

    if (winner != null &&
        (winner.toUpperCase() == 'X' || winner.toUpperCase() == 'O')) {
      /// Return X or O
      return winner.toUpperCase();
    }

    winner = _checkDiagonals(board, size);
    if (winner != null &&
        (winner.toUpperCase() == 'X' || winner.toUpperCase() == 'O')) {
      /// Return X or O
      return winner.toUpperCase();
    }

    /// D for draw
    if (_isBoardFull(board)) return "D";

    /// Null means game is not over.
    return null;
  }

  List<List<String>> _createBoard(List<dynamic> moves, int size) {
    return List.generate(size,
        (i) => List.generate(size, (j) => moves[i * size + j].toString()));
  }

  String? _checkLines(List<List<String>> board, int size) {
    for (int i = 0; i < size; i++) {
      if (_checkSequence(board[i])) {
        print('Check line : ${board[i][0]}');
        return board[i][0];
      }
      List<String> column = List.generate(size, (index) => board[index][i]);
      if (_checkSequence(column)) {
        print('Check line 2 : ${board[0][1]}');

        return board[0][i];
      }
    }
    return null;
  }

  String? _checkDiagonals(List<List<String>> board, int size) {
    List<String> mainDiagonal = List.generate(size, (i) => board[i][i]);
    if (_checkSequence(mainDiagonal)) {
      print('Check line 3: ${board[0][0]}');

      return board[0][0];
    }

    List<String> antiDiagonal =
        List.generate(size, (i) => board[i][size - 1 - i]);
    if (_checkSequence(antiDiagonal)) {
      print('Check line 4: ${board[0][size - 1]}');

      return board[0][size - 1];
    }

    return null;
  }

  bool _checkSequence(List<String> sequence) {
    return sequence.every((cell) => cell == sequence[0] && cell.isNotEmpty);
  }

  bool _isBoardFull(List<List<String>> board) {
    return !board.expand((row) => row).contains(" ");
  }
}
