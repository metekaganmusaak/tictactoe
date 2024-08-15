import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tictactoe/core/constants/gap.dart';
import 'package:tictactoe/core/extensions/focus_unfocus_on_tap.dart';
import 'package:tictactoe/models/room_model.dart';
import 'package:tictactoe/services/core/navigation_service.dart';
import 'package:tictactoe/views/home/home_controller.dart';
import 'package:tictactoe/views/home/widgets/room_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Tic Tac Toe'),
        ),
        floatingActionButton: controller.showEnterNamePopup.value
            ? null
            : FloatingActionButton.extended(
                onPressed: () {
                  Get.toNamed(Routes.createGame);
                },
                label: const Text('Create Game'),
                icon: const Icon(Icons.create),
              ),
        body: controller.showEnterNamePopup.value
            ? Padding(
                padding: const EdgeInsets.all(Gap.l),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Please enter your name to see available game rooms in the lobby',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Gap.m),
                    TextField(
                      controller: controller.nameController,
                      decoration: const InputDecoration(
                        hintText: 'eg: John Doe',
                      ),
                    ),
                    const SizedBox(height: Gap.m),
                    FilledButton(
                      onPressed: () {
                        controller.saveUsername();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              )
            : StreamBuilder(
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
                        'There are no available rooms',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  } else {
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: Gap.m);
                      },
                      itemCount: rooms.length,
                      padding: const EdgeInsets.all(Gap.l),
                      itemBuilder: (context, index) {
                        final room = rooms[index];
                        final roomModel = RoomModel.fromJson(room);
                        return RoomWidget(
                          room: roomModel,
                          onTap: () async {
                            if (roomModel.player1Name == controller.username ||
                                (roomModel.player2Name != null &&
                                    roomModel.player2Name ==
                                        controller.username)) {
                              Get.toNamed(
                                Routes.game,
                                arguments: roomModel,
                              );
                              return;
                            }

                            await controller.updateRoomParticipant(
                              roomModel.id,
                            );

                            Get.toNamed(
                              Routes.game,
                              arguments: roomModel,
                            );
                          },
                        );
                      },
                    );
                  }
                }),
      ).unfocus();
    });
  }
}
