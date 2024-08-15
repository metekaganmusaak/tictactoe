import 'package:flutter/material.dart';
import 'package:tictactoe/core/constants/gap.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      width: double.infinity,
      child: Material(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Gap.l.px),
          topRight: Radius.circular(Gap.l.px),
        ),
        child: SingleChildScrollView(child: body),
      ),
    );
  }
}
