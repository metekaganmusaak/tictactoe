import 'package:flutter/material.dart';

/// Extension to unfocus the current focus when tapped on the widget.
/// Especially we use this extension on the scaffold to unfocus the
/// keyboard when tapped outside the text field.
extension FocusUnfocusOnTap on Widget {
  Widget unfocus() {
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusManager.instance.primaryFocus;
        if (currentFocus != null) {
          currentFocus.unfocus();
        }
      },
      child: this,
    );
  }

  Widget focus() {
    return GestureDetector(
      onTap: () {
        final currentFocus = FocusManager.instance.primaryFocus;
        if (currentFocus != null) {
          currentFocus.requestFocus();
        }
      },
      child: this,
    );
  }
}
