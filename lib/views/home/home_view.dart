import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tictactoe/core/constants/gap.dart';
import 'package:tictactoe/core/extensions/conditional_show.dart';
import 'package:tictactoe/core/extensions/focus_unfocus_on_tap.dart';
import 'package:tictactoe/models/room_model.dart';
import 'package:tictactoe/services/core/localization_service.dart';
import 'package:tictactoe/services/core/navigation_service.dart';
import 'package:tictactoe/views/home/home_controller.dart';
import 'package:tictactoe/views/home/widgets/room_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final showEnterName = controller.showEnterName.value;

      return Scaffold(
        appBar: AppBar(title: Text(Tr.tictactoe.tr)),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.toNamed(Routes.createGame);
          },
          label: Text(Tr.createGameRoom.tr),
          icon: const Icon(Icons.create),
        ).conditionalShow(showEnterName == false, true),
        body: switch (showEnterName) {
          true => _EnterNameWidget(controller: controller),
          false => _GameRoomsWidget(controller: controller),
        },
      ).unfocus();
    });
  }
}

class _GameRoomsWidget extends StatelessWidget {
  const _GameRoomsWidget({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: controller.fetchAllRooms(),
        builder: (context, snapshot) {
          final rooms = snapshot.data;
          if (rooms == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (rooms.isEmpty) {
            return Center(
              child: Text(
                Tr.thereAreNoAvailableRooms.tr,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(height: Gap.m.px);
              },
              itemCount: rooms.length,
              padding: EdgeInsets.all(Gap.l.px),
              itemBuilder: (context, index) {
                final room = rooms[index];
                final roomModel = RoomModel.fromJson(room);
                return RoomWidget(
                  room: roomModel,
                  onTap: () async {
                    /// You are room owner. So you can join the room.
                    if (roomModel.player1Name == controller.currentUsername) {
                      Get.toNamed(
                        Routes.game,
                        arguments: roomModel,
                      );
                      return;
                    }

                    /// You are not room owner. If player 2 seat is empty, you can join.
                    if (roomModel.player2Name == null) {
                      await controller.updateRoomParticipant(
                        roomModel.id,
                      );

                      Get.toNamed(
                        Routes.game,
                        arguments: roomModel,
                      );
                      return;
                    }

                    /// You are not room owner and player 2 seat is already yours.
                    if (roomModel.player2Name == controller.currentUsername) {
                      Get.toNamed(
                        Routes.game,
                        arguments: roomModel,
                      );
                      return;
                    }

                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(Tr.youCanNotJoinThisRoom.tr),
                      ),
                    );
                  },
                );
              },
            );
          }
        });
  }
}

class _EnterNameWidget extends StatelessWidget {
  const _EnterNameWidget({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Gap.l.px),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Tr.pleaseEnterYourNameToSee.tr,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Gap.m.px),
          TextField(
            controller: controller.nameController,
            decoration: InputDecoration(
              hintText: Tr.hintName.tr,
            ),
          ),
          SizedBox(height: Gap.m.px),
          FilledButton(
            onPressed: () {
              controller.saveUsername();
            },
            child: Text(Tr.save.tr),
          ),
        ],
      ),
    );
  }
}
