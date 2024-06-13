import 'package:flutter/material.dart';

/// Widget that displays an error message and a button to retry an action.
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    required this.error,
    required this.onTabRetry,
    super.key,
  });

  final String error;
  final Function() onTabRetry;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onTabRetry,
            child: const Text('Try again'),
          ),
        ],
      );
}
