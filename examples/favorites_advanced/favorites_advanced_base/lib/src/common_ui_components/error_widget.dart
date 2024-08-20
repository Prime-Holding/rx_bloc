import 'package:flutter/material.dart';

class ErrorRetryWidget extends StatelessWidget {
  const ErrorRetryWidget({
    this.onReloadTap,
    super.key,
  });

  final VoidCallback? onReloadTap;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 100),
            ElevatedButton(
              key: const Key('reload_button'),
              child: const Text('Try again'),
              onPressed: onReloadTap,
            )
          ],
        ),
      );
}
