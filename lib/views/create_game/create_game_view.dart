import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tictactoe/core/constants/gap.dart';
import 'package:tictactoe/core/constants/palette.dart';
import 'package:tictactoe/core/extensions/focus_unfocus_on_tap.dart';
import 'package:tictactoe/models/room_model.dart';
import 'package:tictactoe/views/create_game/create_game_controller.dart';
import 'package:tictactoe/views/create_game/widgets/game_mode_widget.dart';
import 'package:tictactoe/views/create_game/widgets/participant_widget.dart';

class CreateGameView extends GetView<CreateGameController> {
  const CreateGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Game')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await controller.createRoom();

          if (result) {
            Get.back();
          }
        },
        label: const Text('Create'),
        icon: const Icon(Icons.create),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Gap.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Room Name',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: Gap.m),
            Obx(() {
              return TextField(
                controller: controller.roomNameController,
                onChanged: (value) => controller.errorText.value = '',
                decoration: InputDecoration(
                  hintText: 'eg: My Room',
                  errorText: controller.errorText.isEmpty
                      ? null
                      : controller.errorText.value,
                ),
              );
            }),
            const SizedBox(height: Gap.xl),
            Text(
              'Game Color',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: Gap.m),
            Wrap(
              children: [
                ...BackgroundColor.values.map((bg) {
                  return GestureDetector(
                    onTap: () {
                      controller.selectedColor.value = bg;
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: Gap.m),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: bg.color,
                        borderRadius: BorderRadius.circular(Gap.m),
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
            const SizedBox(height: Gap.xl),
            Text(
              'Game Mode',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: Gap.m),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...GameLevel.values.map((level) {
                  return Expanded(child: GameModeWidget(level: level));
                }),
              ],
            ),
            const SizedBox(height: Gap.xl),
            Text(
              'Participants',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: Gap.m),
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
            const SizedBox(height: Gap.xl),
          ],
        ),
      ),
    ).unfocus();
  }
}
