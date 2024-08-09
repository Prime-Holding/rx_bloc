import 'package:flutter/material.dart';

/// Custom app divider using a predefined thickness
class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) => const Divider(
        thickness: 0.6,
      );
}
