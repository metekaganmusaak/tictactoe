import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tictactoe/core/constants/gap.dart';
import 'package:tictactoe/core/constants/palette.dart';
import 'package:tictactoe/core/extensions/focus_unfocus_on_tap.dart';
import 'package:tictactoe/models/room_model.dart';
import 'package:tictactoe/services/core/localization_service.dart';
import 'package:tictactoe/views/create_game/create_game_controller.dart';
import 'package:tictactoe/views/create_game/widgets/game_mode_widget.dart';
import 'package:tictactoe/views/create_game/widgets/participant_widget.dart';

class CreateGameView extends GetView<CreateGameController> {
  const CreateGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Tr.createGame.tr)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await controller.createRoom();

          if (result) {
            Get.back();
          }
        },
        label: Text(Tr.create.tr),
        icon: const Icon(Icons.create),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Gap.l.px),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Tr.roomName.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: Gap.m.px),
            Obx(() {
              return TextField(
                controller: controller.roomNameController,
                onChanged: (value) => controller.errorText.value = '',
                decoration: InputDecoration(
                  hintText: Tr.roomNameHint.tr,
                  errorText: controller.errorText.isEmpty
                      ? null
                      : controller.errorText.value,
                ),
              );
            }),
            SizedBox(height: Gap.xl.px),
            Text(
              Tr.gameColor.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: Gap.m.px),
            Wrap(
              children: [
                ...BackgroundColor.values.map((bg) {
                  return GestureDetector(
                    onTap: () {
                      controller.selectedColor.value = bg;
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: Gap.m.px),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: bg.color,
                        borderRadius: BorderRadius.circular(Gap.m.px),
                      ),
                      child: Center(
                        child: Obx(() {
                          return Icon(
                            Icons.check,
                            color: controller.selectedColor.value == bg
                                ? Palette.black
                                : Colors.transparent,
                          );
                        }),
                      ),
                    ),
                  );
                }),
              ],
            ),
            SizedBox(height: Gap.xl.px),
            Text(
              Tr.gameMode.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: Gap.m.px),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...GameLevel.values.map((level) {
                  return Expanded(child: GameModeWidget(level: level));
                }),
              ],
            ),
            SizedBox(height: Gap.xl.px),
            Text(
              Tr.participants.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: Gap.m.px),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: ParticipantWidget(isGameCreator: true)),
                Text(
                  'vs',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const Expanded(child: ParticipantWidget(isGameCreator: false)),
              ],
            ),
            SizedBox(height: Gap.xl.px),
          ],
        ),
      ),
    ).unfocus();
  }
}
