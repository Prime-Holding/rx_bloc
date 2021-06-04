// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../app_extensions.dart';
import '../../base/utils/helpers.dart';

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
              _buildRequestPermissionsButton(context),
              _buildButton(context, 'Show notification', () {
                //
              }),
              _buildButton(context, 'Show notification after 5 seconds'),
            ],
          ),
        ),
      );

  /// region Builders

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

  Widget _buildRequestPermissionsButton(BuildContext context) =>
      _buildButton(context, 'Request notification permissions', () async {
        /// TODO: Move this to Notifications bloc
        final res = await FirebaseMessaging.instance.requestPermission();
        if (res.authorizationStatus == AuthorizationStatus.denied) {
          await showAdaptiveDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Container(
                child: Text(
                  context.l10n.notificationsPermissionsDenied,
                  textAlign: TextAlign.center,
                ),
              ),
              actions: <Widget>[
                Center(
                  child: TextButton(
                    onPressed: () => context.router.pop(),
                    child: Text(
                      context.l10n.ok,
                      style: context.designSystem.typography.buttonFaded,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      });

  /// endregion
}
