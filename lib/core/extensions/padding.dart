import 'package:flutter/material.dart';
import 'package:tictactoe/core/constants/gap.dart';

extension PaddingExtension on Widget {
  Widget paddingAll(Gap gap) {
    return Padding(
      padding: EdgeInsets.all(gap.px),
      child: this,
    );
  }

  Widget paddingSymmetric({Gap vertical = Gap.no, Gap horizontal = Gap.no}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: vertical.px,
        horizontal: horizontal.px,
      ),
      child: this,
    );
  }

  Widget paddingOnly({
    Gap left = Gap.no,
    Gap right = Gap.no,
    Gap top = Gap.no,
    Gap bottom = Gap.no,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left.px,
        right: right.px,
        top: top.px,
        bottom: bottom.px,
      ),
      child: this,
    );
  }
}
