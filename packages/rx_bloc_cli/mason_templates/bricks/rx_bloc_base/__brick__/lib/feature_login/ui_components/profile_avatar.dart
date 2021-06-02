import 'package:flutter/material.dart';

import '../../app_extensions.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    this.loggedIn = false,
    Key? key,
  }) : super(key: key);

  final bool loggedIn;

  @override
  Widget build(BuildContext context) => _buildAvatarChild(context);

  Widget _buildAvatarChild(BuildContext context) =>
      loggedIn ? _buildLoggedInAvatar(context) : _buildLoginButton(context);

  Widget _buildLoginButton(BuildContext context) => Padding(
    padding: const EdgeInsets.all(12),
    child: OutlinedButton(
      onPressed: () {},
      child: Text(
        context.l10n.logIn,
        style: context.designSystem.typography.buttonFaded,
      ),
    ),
  );

  Widget _buildLoggedInAvatar(BuildContext context) => Container();
}
