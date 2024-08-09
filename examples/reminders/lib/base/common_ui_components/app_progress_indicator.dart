import 'package:flutter/material.dart';

/// Widget that displays a circular progress indicator in the center of the
/// screen. Intended to be used as a loading indicator while data is being
/// fetched.
class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator(),
      );
}
