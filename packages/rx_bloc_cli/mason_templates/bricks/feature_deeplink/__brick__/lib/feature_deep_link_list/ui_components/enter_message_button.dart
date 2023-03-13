{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../feature_enter_message/di/enter_message_with_dependencies.dart';
import '../blocs/deep_link_list_bloc.dart';

class EnterMessageButton extends StatelessWidget {
  const EnterMessageButton({
    required this.isActive,
    Key? key,
  }) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () async {
          final response = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const EnterMessageWithDependencies(),
            ),
          );

          if (response == null) {
            return;
          }

          if (context.mounted) {
            context.read<DeepLinkListBlocType>().events.setMessage(response);
          }
        },
        icon: Icon(
          context.designSystem.icons.message,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        tooltip: context.l10n.pageWithResult,
        color: (isActive
            ? context.designSystem.colors.activeButtonTextColor
            : context.designSystem.colors.inactiveButtonTextColor),
      );
}
