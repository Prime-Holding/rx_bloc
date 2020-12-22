import 'package:flutter/material.dart';

/// TODO: Move that widget to the favorites_advanced_base package
class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      );
}
