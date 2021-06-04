import 'package:flutter/material.dart';

import '../../app_extensions.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.notificationPageTitle),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(context, 'Request notification permissions'),
              _buildButton(context, 'Show notification'),
              _buildButton(context, 'Show notification after 5 seconds'),
            ],
          ),
        ),
      );

  Widget _buildButton(
    BuildContext context,
    String label, [
    Function()? onPressed,
  ]) =>
      Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: OutlinedButton(
            onPressed: () => onPressed?.call(),
            child: Text(
              label,
              style: context.designSystem.typography.buttonFaded,
            ),
          ),
        ),
      );
}
