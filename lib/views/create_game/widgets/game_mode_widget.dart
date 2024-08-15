import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tictactoe/core/constants/gap.dart';
import 'package:tictactoe/core/constants/palette.dart';
import 'package:tictactoe/models/room_model.dart';
import 'package:tictactoe/views/create_game/create_game_controller.dart';

class GameModeWidget extends StatelessWidget {
  const GameModeWidget({
    super.key,
    required this.level,
  });

  final GameLevel level;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.find<CreateGameController>().selectedLevelIndex.value = level.value;
      },
      child: Obx(() {
        return Container(
          padding: EdgeInsets.all(Gap.l.px),
          margin: EdgeInsets.symmetric(horizontal: Gap.xs.px),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Gap.l.px),
            border: Border.all(color: Theme.of(context).primaryColor),
            color: Get.find<CreateGameController>().selectedLevelIndex.value ==
                    level.value
                ? Palette.grey.withOpacity(0.4)
                : Palette.grey.withOpacity(0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(level.name),
              Text(
                level.boardType,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Radio<int>(
                value: level.value,
                groupValue:
                    Get.find<CreateGameController>().selectedLevelIndex.value,
                onChanged: (value) {
                  Get.find<CreateGameController>().selectedLevelIndex.value =
                      value!;
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
