 {{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:widget_toolkit/models.dart';
import 'package:widget_toolkit/ui_components.dart';{{#enable_pin_code}}
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';{{/enable_pin_code}}

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/common_ui_components/app_divider.dart';
import '../../base/common_ui_components/app_list_tile.dart'; {{#enable_change_language}}
import '../../lib_change_language/bloc/change_language_bloc.dart';
import '../../lib_change_language/extensions/language_model_extensions.dart';
import '../../lib_change_language/ui_components/language_picker_button.dart'; {{/enable_change_language}}{{#enable_pin_code}}
import '../../lib_pin_code/bloc/create_pin_bloc.dart';
import '../../lib_pin_code/bloc/update_and_verify_pin_bloc.dart';
import '../../lib_pin_code/models/pin_code_arguments.dart'; {{/enable_pin_code}}
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../blocs/profile_bloc.dart';
import '../extensions/push_notifications_extensions.dart';{{#has_authentication}}
import '../ui_components/logout_action_button.dart';{{/has_authentication}}


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
     context.read<ProfileBlocType>().events.loadNotificationsSettings(); {{#enable_pin_code}}
    context
        .read<CreatePinBlocType>()
        .events
        .checkIsPinCreated(); {{/enable_pin_code}}
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar({{#has_authentication}}
          actions: const [
            LogoutActionButton(),
          ],
        {{/has_authentication}}),
        body:ListView(
            shrinkWrap: true,
            children: [
            _buildUserInfo(context),
            AppListTile(
                onTap: () => context
                    .read<RouterBlocType>()
                    .events
                    .push(const NotificationsRoute()),
                featureTitle:
                    context.l10n.featureNotifications.notificationPageTitle,
                featureSubtitle:
                    context.l10n.featureNotifications.notificationPageSubtitle,
                icon: context.designSystem.icons.notifications,
              ),
            const AppDivider(), {{#enable_change_language}}
            LanguagePickerButton(
                onChanged: (language) => context
                    .read<ChangeLanguageBlocType>()
                    .events
                    .setCurrentLanguage(language),
                buttonText:
                    context.l10n.featureProfile.profilePageChangeLanguageButton,
                translate: (model) => model.asText(context),
              ),
            const AppDivider(),{{/enable_change_language}} {{#enable_pin_code}}
            RxBlocBuilder<CreatePinBlocType, bool>(
                state: (bloc) => bloc.states.isPinCreated,
                builder: (context, isPinCreated, bloc) => AppListTile(
                  featureTitle: _buildPinButtonText(isPinCreated, context),
                  icon: context.designSystem.icons.pin,
                  featureSubtitle: context.l10n.libPinCode.pinCodeSubtitle,
                  onTap: () {
                    if (isPinCreated.hasData && isPinCreated.data!) {
                      context
                          .read<UpdateAndVerifyPinBlocType>()
                          .events
                          .deleteSavedData();
                      context.read<RouterBlocType>().events.push(
                            const UpdatePinRoute(),
                            extra: PinCodeArguments(
                                title: context.l10n.libPinCode.enterCurrentPin),
                          );
                    } else {
                      context
                          .read<CreatePinBlocType>()
                          .events
                          .deleteSavedData();
                      context.read<RouterBlocType>().events.push(
                            const CreatePinRoute(),
                            extra: PinCodeArguments(
                              title: context.l10n.libPinCode.createPin,
                            ),
                          );
                    }
                  },
                ),
              ),
              const AppDivider(),
              AppListTile(
                featureTitle: context.l10n.libPinCode.biometricsTitle,
                featureSubtitle: context.l10n.libPinCode.biometricsSubtitle,
                icon: context.designSystem.icons.fingerprint,
                trailing: BiometricsSwitch(
                  biometricsLocalDataSource: context.read<BiometricsLocalDataSource>(),
                ),
              ),
              const AppDivider(), {{/enable_pin_code}}
              RxBlocBuilder<ProfileBlocType, Result<bool>>(
                state: (bloc) => bloc.states.areNotificationsEnabled,
                builder: (context, areNotificationsEnabled, bloc) =>
                    AppListTile(
                  featureTitle: context
                      .l10n.featureProfile.profilePageEnableNotificationText,
                  featureSubtitle: areNotificationsEnabled.value
                      ? context
                          .l10n.featureProfile.notificationsSubtitleDeactivete
                      : context
                          .l10n.featureProfile.notificationsSubtitleActivete,
                  icon: areNotificationsEnabled.value
                      ? context.designSystem.icons.notificationsActive
                      : context.designSystem.icons.notificationsInactive,
                  trailing: Switch(
                    value: areNotificationsEnabled.value,
                    onChanged: (_) => bloc.events.setNotifications(
                      !areNotificationsEnabled.value,
                    ),
                  ),
                ),
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
            ),
            {{#enable_pin_code}}
            RxBlocListener<CreatePinBlocType, bool>(
              state: (bloc) => bloc.states.isPinCreated,
              condition: (previous, current) =>
                  previous != current && current == true,
              listener: (context, isCreated) async {
                if (isCreated) {
                  await showBlurredBottomSheet(
                    context: context,
                    configuration:
                        const ModalConfiguration(safeAreaBottom: false),
                    builder: (context) => MessagePanelWidget(
                      message: context.l10n.libPinCode.pinCreatedMessage,
                      messageState: MessagePanelState.positiveCheck,
                    ),
                  );
                }
              },
             ),
             RxBlocListener<UpdateAndVerifyPinBlocType, void>(
               state: (bloc) => bloc.states.isPinUpdated,
               listener: (context, isCreated) async {
                 await showBlurredBottomSheet(
                   context: context,
                   configuration:
                       const ModalConfiguration(safeAreaBottom: false),
                   builder: (context) => MessagePanelWidget(
                     message: context.l10n.libPinCode.pinUpdatedMessage,
                     messageState: MessagePanelState.positiveCheck,
                   ),
                 );
               },
             ),
             {{/enable_pin_code}}
          ],
        ),
      );

  Widget _buildUserInfo(BuildContext context) => Padding(
        padding: EdgeInsets.all(
          context.designSystem.spacing.xs,
        ),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.designSystem.spacing.l,
                ),
                child: CircleAvatar(
                  backgroundColor: context.designSystem.colors.primaryColor,
                  radius: 50,
                  child: Icon(
                    context.designSystem.icons.avatar,
                    size: 75,
                    color: context.designSystem.colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: context.designSystem.spacing.l,
                ),
                child: Text(
                  'John Doe',
                  style: context.designSystem.typography.h1Bold20,
                ),
              ),
            ],
          ),
        ),
      );

  {{#enable_pin_code}}
  String _buildPinButtonText(
      AsyncSnapshot<bool> isPinCreated, BuildContext context) {
    if (isPinCreated.hasData) {
      if (isPinCreated.data!) {
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
