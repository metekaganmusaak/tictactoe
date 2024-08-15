import 'package:flutter/material.dart';

extension ConditionalShow on Widget {
  Widget? conditionalShow(bool condition,
      [bool isNullableReturnTypeAcceptable = true]) {
    if (condition) {
      return this;
    } else {
      return isNullableReturnTypeAcceptable ? null : const SizedBox.shrink();
    }
  }
}
