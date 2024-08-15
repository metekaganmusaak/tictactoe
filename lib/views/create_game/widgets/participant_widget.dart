import 'package:flutter/material.dart';
import 'package:tictactoe/core/constants/gap.dart';
import 'package:tictactoe/core/constants/palette.dart';

class ParticipantWidget extends StatelessWidget {
  const ParticipantWidget({super.key, required this.isGameCreator});

  final bool isGameCreator;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: EdgeInsets.all(Gap.l.px),
      margin: EdgeInsets.symmetric(horizontal: Gap.m.px),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Gap.l.px),
        color: isGameCreator ? Palette.green : Palette.red,
      ),
      child: Stack(
        children: [
          Positioned(
            left: isGameCreator ? -40 : null,
            bottom: isGameCreator ? -20 : null,
            right: isGameCreator ? null : -40,
            top: isGameCreator ? null : -20,
            child: Icon(
              Icons.person,
              size: 128,
              color: Palette.white.withOpacity(0.2),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isGameCreator ? 'Player X' : 'Player O',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  isGameCreator
                      ? 'You'.toUpperCase()
                      : 'Opponent'.toUpperCase(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
