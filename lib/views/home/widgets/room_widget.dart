import 'package:flutter/material.dart';
import 'package:tictactoe/core/constants/gap.dart';
import 'package:tictactoe/core/constants/palette.dart';
import 'package:tictactoe/models/room_model.dart';

class RoomWidget extends StatelessWidget {
  const RoomWidget({
    super.key,
    required this.room,
    required this.onTap,
  });

  final RoomModel room;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Gap.l),
      decoration: BoxDecoration(
        color: BackgroundColor.values[room.backgroundColor].color,
        borderRadius: BorderRadius.circular(Gap.m),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Palette.black,
                      ),
                ),
                const SizedBox(height: Gap.m),
                Text(
                  'Game Mode: ${GameLevel.values[room.level].name} - ${GameLevel.values[room.level].boardType}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Palette.black,
                      ),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: room.isFinished ? null : onTap,
            label: const Text('Start'),
            icon: const Icon(Icons.play_arrow),
            style: FilledButton.styleFrom(
              foregroundColor: Palette.black,
              backgroundColor: Palette.black.withOpacity(
                0.15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
