import 'package:flutter/widgets.dart';

extension FocusNodeExtensions on FocusNode {
  /// Requests focus on the [FocusNode] if it is not disposed and the underlying
  /// context is still part of the widget tree.
  void requestFocusSafely(BuildContext context) {
    if (canRequestFocus && this.context != null && context.mounted) {
      FocusScope.of(context).requestFocus(this);
    }
  }
}
