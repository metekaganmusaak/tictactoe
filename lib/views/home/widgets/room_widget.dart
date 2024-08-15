import 'package:flutter/material.dart';
import 'package:tictactoe/core/constants/gap.dart';
import 'package:tictactoe/core/constants/palette.dart';
import 'package:tictactoe/models/room_model.dart';
import 'package:tictactoe/services/core/localization_service.dart';

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
      padding: EdgeInsets.all(Gap.l.px),
      decoration: BoxDecoration(
        color: BackgroundColor.values[room.backgroundColor].color,
        borderRadius: BorderRadius.circular(Gap.m.px),
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
                SizedBox(height: Gap.m.px),
                Text(
                  '${GameLevel.values[room.level].name} - ${GameLevel.values[room.level].boardType}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Palette.black,
                      ),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: room.isFinished ? null : onTap,
            label: Text(Tr.join.tr),
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
