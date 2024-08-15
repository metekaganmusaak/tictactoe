import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/core/constants/gap.dart';
import 'package:tictactoe/core/constants/palette.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({
    super.key,
    required this.avatar,
    required this.username,
    required this.isRoomOwner,
    required this.moveTurn,
  });

  final bool isRoomOwner;
  final String avatar;
  final String username;
  final bool moveTurn;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AvatarGlow(
          animate: moveTurn,
          glowColor: isRoomOwner ? Palette.green : Palette.red,
          child: CircleAvatar(
            radius: 40,
            backgroundColor: isRoomOwner
                ? Palette.green.withOpacity(0.8)
                : Palette.red.withOpacity(0.8),
            child: Text(
              avatar,
              style: const TextStyle(color: Palette.white),
            ),
          ),
        ),
        SizedBox(height: Gap.m.px),
        Text(
          username,
          style: const TextStyle(color: Palette.black),
        ),
      ],
    );
  }
}
