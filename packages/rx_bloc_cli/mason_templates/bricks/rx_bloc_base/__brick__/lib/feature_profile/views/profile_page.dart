{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/ui_components.dart';
import '../../app_extensions.dart';{{#enable_change_language}}
import '../../lib_change_language/bloc/change_language_bloc.dart';
import '../../lib_change_language/extensions/language_model_extensions.dart';
import '../../lib_change_language/ui_components/language_picker_button.dart';{{/enable_change_language}}
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';{{#has_authentication}}
import '../ui_components/logout_action_button.dart';{{/has_authentication}}

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar({{#has_authentication}}
          actions: const [
            LogoutActionButton(),
          ],
        {{/has_authentication}}),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.designSystem.spacing.xl0,
              ),
              child: OutlineFillButton(
                text: context.l10n.featureNotifications.notificationPageTitle,
                onPressed: () => context
                    .read<RouterBlocType>()
                    .events
                    .push(const NotificationsRoute()),
              ),
            ),
            SizedBox(
              height: context.designSystem.spacing.xl0,
            ),{{#enable_change_language}}
            LanguagePickerButton(
              onChanged: (language) => context
                  .read<ChangeLanguageBlocType>()
                  .events
                  .setCurrentLanguage(language),
              padding: context.designSystem.spacing.xl0,
              buttonText: context.l10n.changeLanguage,
              translate: (model) => model.asText(context),
            ),{{/enable_change_language}}
          ],
        ),
      );
}
