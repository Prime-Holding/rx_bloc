{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:widget_toolkit/models.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';{{#enable_change_language}}
import '../../lib_change_language/bloc/change_language_bloc.dart';
import '../../lib_change_language/extensions/language_model_extensions.dart';
import '../../lib_change_language/ui_components/language_picker_button.dart';{{/enable_change_language}}{{#enable_pin_code}}
import '../../lib_pin_code/bloc/pin_bloc.dart';{{/enable_pin_code}}
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../blocs/profile_bloc.dart';
import '../extensions/push_notifications_extensions.dart';
import '../ui_components/logout_action_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      context.read<ProfileBlocType>().events.loadNotificationsSettings();
    }
  }

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
              buttonText:
                  context.l10n.featureProfile.profilePageChangeLanguageButton,
              translate: (model) => model.asText(context),
            ),{{/enable_change_language}}
             SizedBox(
              height: context.designSystem.spacing.xl0,
            ),
            AppErrorModalWidget<ProfileBlocType>(
              errorState: (bloc) => bloc.states.errors,
            ),
            RxBlocListener<ProfileBlocType, Result<bool>>(
              state: (bloc) => bloc.states.syncNotificationsStatus,
              condition: (previous, current) => current is ResultSuccess<bool>,
              listener: (context, state) {
                if (state.tag.isLoadingSubscription) {
                  showBlurredBottomSheet(
                    context: context,
                    builder: (BuildContext context) => MessagePanelWidget(
                      message: (state as ResultSuccess<bool>)
                          .data
                          .translate(context),
                      messageState: MessagePanelState.positiveCheck,
                    ),
                  );
                }
              },
              child: const SizedBox(),
            ),
            ListTile(
              title: Text(context
                  .l10n.featureProfile.profilePageEnableNotificationText),
              trailing: RxBlocBuilder<ProfileBlocType, Result<bool>>(
                state: (bloc) => bloc.states.areNotificationsEnabled,
                builder: (context, areNotificationsEnabled, bloc) => Switch(
                  value: areNotificationsEnabled.value,
                  onChanged: (_) => bloc.events.setNotifications(
                    !areNotificationsEnabled.value,
                  ),
                ),
              ),
            ),
            ), {{/enable_change_language}}{{#enable_pin_code}}
            SizedBox(
              height: context.designSystem.spacing.xl0,
            ),
            RxBlocBuilder<PinBlocType, bool>(
              state: (bloc) => bloc.states.isVerificationPinCorrect,
              builder: (context, isVerificationPinCorrect, bloc) =>
                  RxBlocBuilder<PinBlocType, bool>(
                    state: (bloc) => bloc.states.isPinCreated,
                    builder: (context, createdPin, bloc) =>
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.designSystem.spacing.xl0,
                          ),
                          child: OutlineFillButton(
                            text: _buildPinButtonText(createdPin, context),
                            onPressed: () =>
                                context
                                    .read<RouterBlocType>()
                                    .events
                                    .push(
                                  const PinCodeRoute(),
                                  extra: _buildExtraText(
                                      createdPin, isVerificationPinCorrect,
                                      context),
                                ),
                          ),
                        ),
                  ),
            )
            ,
          ],
        ),
      );

  String _buildExtraText(AsyncSnapshot<bool> createdPin,
      AsyncSnapshot<bool> isVerificationPinCorrect, BuildContext context) {
    if (createdPin.hasData && createdPin.data!) {
      if (createdPin.data!) {
        if (isVerificationPinCorrect.hasData &&
            isVerificationPinCorrect.data!) {
          return context.l10n.libPinCode.enterNewPin;
        }
        return context.l10n.libPinCode.enterCurrentPin;
      }
    }
    return context.l10n.libPinCode.createPin;
  }

  String _buildPinButtonText(AsyncSnapshot<bool> snapshot,
      BuildContext context) {
    if (snapshot.hasData) {
      if (snapshot.data!) {
        return context.l10n.libPinCode.changePin;
      }
      return context.l10n.libPinCode.createPin;
    }
    return context.l10n.libPinCode.createPin;
  } {{/enable_pin_code}}

}
extension _StringX on String {
  bool get isLoadingSubscription =>
      this == ProfileBloc.tagNotificationUnsubscribe ||
      this == ProfileBloc.tagNotificationSubscribe;
}
