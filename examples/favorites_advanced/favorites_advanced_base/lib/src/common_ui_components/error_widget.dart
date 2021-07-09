import 'package:flutter/material.dart';

class ErrorRetryWidget extends StatelessWidget {
  const ErrorRetryWidget({Key? key, this.onReloadTap, this.textError = ''})
      : super(key: key);

  final String textError;
  final VoidCallback? onReloadTap;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 100),
            if (textError.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  textError,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ElevatedButton(
              child: const Text('Try again'),
              onPressed: onReloadTap,
            )
          ],
        ),
      );
}
