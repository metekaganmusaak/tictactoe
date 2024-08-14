import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tictactoe/core/constants/gap.dart';
import 'package:tictactoe/core/constants/palette.dart';
import 'package:tictactoe/models/room_model.dart';
import 'package:tictactoe/views/game/game_controller.dart';
import 'package:tictactoe/views/game/widgets/player_widget.dart';

class GameView extends GetView<GameController> {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          BackgroundColor.values[controller.room.backgroundColor].color,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Palette.black),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Leave Game'),
                      content: const Text(
                        'Do you want to leave the game? If you leave, you will lose the game.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            Get.close(2);
                            final result = await controller.finishGame();

                            if (result.isErr()) {
                              Get.snackbar(
                                'Error',
                                result.unwrapErr(),
                                backgroundColor: Palette.red,
                                colorText: Palette.white,
                              );
                              return;
                            }
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('No'),
                        ),
                      ],
                    );
                  });
            }),
        title: Text(
          controller.room.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Palette.black,
              ),
        ),
        backgroundColor:
            BackgroundColor.values[controller.room.backgroundColor].color,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: controller.gameStream(),
          builder: (context, snapshot) {
            final game = snapshot.data;
            if (game == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final currentGame = RoomModel.fromJson(game.first);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(Gap.l),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Player X',
                          style: TextStyle(
                            fontSize: 24,
                            color: Palette.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Player O',
                          style: TextStyle(
                            fontSize: 24,
                            color: Palette.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Gap.m),
                  Row(
                    children: [
                      Expanded(
                        child: PlayerWidget(
                          avatar: controller.userFirstLetters(
                            currentGame.player1Name,
                          ),
                          username: currentGame.player1Name,
                          isRoomOwner: true,
                          moveTurn:
                              controller.turn.value == GameMoveTurn.player1,
                        ),
                      ),
                      Expanded(
                        child: PlayerWidget(
                          avatar: controller.userFirstLetters(
                            currentGame.player2Name ?? 'Anonymous',
                          ),
                          username: currentGame.player2Name ?? 'Anonymous',
                          isRoomOwner: false,
                          moveTurn:
                              controller.turn.value == GameMoveTurn.player2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Gap.xl),
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          GameLevel.values[currentGame.level].boardSize,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          controller.makeMove(index);
                        },
                        child: Container(
                          color: Palette.white.withOpacity(0.5),
                          child: Center(
                            child: Text(
                              currentGame.moves[index],
                              style: const TextStyle(
                                fontSize: 24,
                                color: Palette.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: GameLevel.values[currentGame.level].boardSize *
                        GameLevel.values[currentGame.level].boardSize,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
