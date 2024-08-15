import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tictactoe/core/constants/gap.dart';
import 'package:tictactoe/core/constants/palette.dart';
import 'package:tictactoe/models/room_model.dart';
import 'package:tictactoe/services/remote/auth_service.dart';
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
              Get.back();
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
      body: Obx(() {
        final winnerName = controller.winnerName.value;
        return StreamBuilder<List<Map<String, dynamic>>>(
            stream: controller.gameStream(),
            builder: (context, snapshot) {
              final data = snapshot.data ?? [];
              final game =
                  data.isNotEmpty ? RoomModel.fromJson(data.first) : null;

              if (game == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (winnerName == 'X' || winnerName == 'O' || winnerName == 'D') {
                return Dialog(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Gap.l.px,
                      horizontal: Gap.xl.px,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (controller.winnerName.value == 'X' ||
                            controller.winnerName.value == 'O') ...[
                          Text(
                            '${controller.winnerName.value} is the winner!',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: Gap.m.px),
                          const Text(
                            'Game room will be deleted in 3 seconds. Please wait...',
                            textAlign: TextAlign.center,
                          ),
                        ],
                        if (controller.winnerName.value == 'D') ...[
                          Text(
                            'DRAW',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: Gap.m.px),
                          const Text(
                            'Game will be restarted in 3 seconds. Please wait...',
                            textAlign: TextAlign.center,
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.all(Gap.l.px),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Player X',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Palette.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                game.player1Name ==
                                        Get.find<AuthService>().getUsername()
                                    ? '(You)'
                                    : '(Opponent)',
                                style: const TextStyle(color: Palette.black),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Player O',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Palette.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                game.player2Name ==
                                        Get.find<AuthService>().getUsername()
                                    ? '(You)'
                                    : '(Opponent)',
                                style: const TextStyle(color: Palette.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Gap.m.px),
                    Row(
                      children: [
                        Expanded(
                          child: PlayerWidget(
                            avatar:
                                controller.userFirstLetters(game.player1Name),
                            username: game.player1Name,
                            isRoomOwner: true,
                            moveTurn:
                                controller.turn.value == GameMoveTurn.player1,
                          ),
                        ),
                        Expanded(
                          child: PlayerWidget(
                            avatar: controller.userFirstLetters(
                              game.player2Name ?? 'Anonymous',
                            ),
                            username: game.player2Name ?? 'Anonymous',
                            isRoomOwner: false,
                            moveTurn:
                                controller.turn.value == GameMoveTurn.player2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Gap.xl.px),
                    GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: GameLevel.values[game.level].boardSize,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                      ),
                      itemCount: GameLevel.values[game.level].boardSize *
                          GameLevel.values[game.level].boardSize,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            await controller.makeMove(index);
                          },
                          child: Container(
                            color: Palette.white.withOpacity(0.5),
                            child: Center(
                              child: Text(
                                game.moves[index],
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: game.moves[index] == 'X'
                                      ? Palette.green
                                      : Palette.red,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            });
      }),
    );
  }
}
