{{> licence.dart }}

import 'package:flutter/material.dart';{{#enable_pin_code}}
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';{{/enable_pin_code}}
import 'package:provider/provider.dart';
import 'package:widget_toolkit/ui_components.dart';
import '../../app_extensions.dart';{{#enable_change_language}}
import '../../lib_change_language/bloc/change_language_bloc.dart';
import '../../lib_change_language/extensions/language_model_extensions.dart';
import '../../lib_change_language/ui_components/language_picker_button.dart';{{/enable_change_language}}{{#enable_pin_code}}
import '../../lib_pin_code/bloc/pin_bloc.dart';
import '../../lib_pin_code/models/pin_code_data.dart';{{/enable_pin_code}}
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../ui_components/logout_action_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: const [
            LogoutActionButton(),
          ],
        ),
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
            ),{{/enable_change_language}}{{#enable_pin_code}}
            SizedBox(
              height: context.designSystem.spacing.xl0,
            ),
            RxBlocBuilder<PinBlocType, PinCodeData>(
              state: (bloc) => bloc.states.pinCodeData,
              builder: (context, snapshot, bloc) => Padding(
                 padding: EdgeInsets.symmetric(
                 horizontal: context.designSystem.spacing.xl0,
                ),
                child: OutlineFillButton(
                  text: _buildCreateOrChangeText(snapshot, context),
                  onPressed: () => context.read<RouterBlocType>().events.push(
                        const PinCodeRoute(),
                         extra: _buildCreateOrChangeText(snapshot, context),
                      ),
                ),
              ),
            ),{{/enable_pin_code}}
          ],
        ),
      ); {{#enable_pin_code}}

  String _buildCreateOrChangeText(
          AsyncSnapshot<PinCodeData> snapshot, BuildContext context) =>
      snapshot.hasData
          ? snapshot.data!.isPinCodeCreated
              ? context.l10n.libPinCode.changePin
              : context.l10n.libPinCode.createPin
          : context.l10n.libPinCode.createPin; {{/enable_pin_code}}

}
