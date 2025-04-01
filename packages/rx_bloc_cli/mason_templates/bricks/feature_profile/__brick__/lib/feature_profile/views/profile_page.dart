 {{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:widget_toolkit/models.dart';
import 'package:widget_toolkit/widget_toolkit.dart';{{#enable_pin_code}}
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';{{/enable_pin_code}}

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/common_ui_components/app_divider.dart';
import '../../base/common_ui_components/app_list_tile.dart';
import '../../base/models/user_model.dart';  {{#enable_feature_onboarding}}
import '../../feature_email_change/di/email_change_page_with_dependencies.dart'; {{/enable_feature_onboarding}}
import '../../lib_auth/blocs/user_account_bloc.dart';{{#enable_change_language}}
import '../../lib_change_language/bloc/change_language_bloc.dart';
import '../../lib_change_language/extensions/language_model_extensions.dart';
import '../../lib_change_language/ui_components/language_picker_button.dart'; {{/enable_change_language}}
import '../../lib_router/router.dart';
import '../blocs/profile_bloc.dart';
import '../extensions/push_notifications_extensions.dart';{{#has_authentication}}
import '../ui_components/logout_action_button.dart';{{/has_authentication}}


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 225,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'John Doe',
                  style: context.designSystem.typography.h1Bold20,
                ),
                centerTitle: true,
                background: Padding(
                  padding: EdgeInsets.only(
                    top: context.designSystem.spacing.xxxxl1,
                    bottom: context.designSystem.spacing.xxxl,
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: context.designSystem.spacing.l,
                      ),
                      child: CircleAvatar(
                        backgroundColor:
                            context.designSystem.colors.primaryColor,
                        radius: 50,
                        child: Icon(
                          context.designSystem.icons.avatar,
                          size: 75,
                          color: context.designSystem.colors.circleAvatarColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              {{#has_authentication}}
              actions: const [
                LogoutActionButton(),
              ],
              {{/has_authentication}}
            ),
            SliverList(
              delegate: SliverChildListDelegate([ {{#enable_feature_onboarding}}
                 AppListTile(
                  featureTitle: context.l10n.featureOnboarding.changeEmail,
                  featureSubtitle: context.l10n.featureOnboarding.manageEmail,
                  icon: context.designSystem.icons.accountIcon,
                  onTap: () => showBlurredBottomSheet(
                    context: context,
                    configuration: ModalConfiguration(
                      safeAreaBottom: false,
                      haveOnlyOneSheet: false,
                    ),
                    builder: (BuildContext context) =>
                        const EmailChangePageWithDependencies(),
                  ),
                ),
                const AppDivider(),
                AppListTile(
                  featureTitle:
                      context.l10n.featureOnboarding.changePhoneNumber,
                  featureSubtitle:
                      context.l10n.featureOnboarding.managePhoneNumber,
                  icon: context.designSystem.icons.phoneIcon,
                  onTap: () => GoRouter.of(context)
                      .push(const PhoneChangeRoute().location),
                ),
                const AppDivider(),{{/enable_feature_onboarding}}
                {{#enable_pin_code}}
                RxBlocBuilder<UserAccountBlocType, UserModel?>(
                  state: (bloc) => bloc.states.currentUser,
                  builder: (context, user, bloc) => AppListTile(
                    featureTitle: _buildPinButtonText(user, context),
                    icon: context.designSystem.icons.pin,
                    featureSubtitle: context.l10n.libPinCode.pinCodeSubtitle,
                    onTap: () => _onPinTileTap(context, user),
                  ),
                ),
                const AppDivider(),
                {{/enable_pin_code}}
                {{#enable_change_language}}
                LanguagePickerButton(
                  onChanged: (language) => context
                      .read<ChangeLanguageBlocType>()
                      .events
                      .setCurrentLanguage(language),
                  buttonText: context
                      .l10n.featureProfile.profilePageChangeLanguageButton,
                  translate: (model) => model.asText(context),
                ),
                const AppDivider(),
                {{/enable_change_language}}
                {{#enable_pin_code}}
                BiometricsSwitch(
                  biometricsLocalDataSource:
                      context.read<BiometricsLocalDataSource>(),
                  builder: (context, areEnabled, callback) => AppListTile(
                    onTap: () => callback(!areEnabled),
                    featureTitle: context.l10n.libPinCode.biometricsTitle,
                    featureSubtitle: context.l10n.libPinCode.biometricsSubtitle,
                    icon: context.designSystem.icons.fingerprint,
                    trailing: Switch(
                      value: areEnabled,
                      onChanged: callback,
                    ),
                  ),
                ),
                const AppDivider(),
                {{/enable_pin_code}}
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
                      onChanged: (_) => bloc.events.toggleNotifications(),
                    ),
                    onTap: () => bloc.events.toggleNotifications(),
                  ),
                ),
                AppErrorModalWidget<ProfileBlocType>(
                  errorState: (bloc) => bloc.states.errors,
                ),
                  RxBlocListener<ProfileBlocType, Result<bool>>(
                  state: (bloc) => bloc.states.areNotificationsEnabled.skip(1),
                  condition: (previousState, currentState) =>
                      previousState is Result<bool>,
                 listener: _onNotificationStateChanged,
                ),{{#enable_feature_onboarding}}
                RxBlocListener<ProfileBlocType, void>(
                  state: (bloc) => bloc.states.phoneNumberUpdated,
                  listener: (context, _) => showBlurredBottomSheet(
                    context: context,
                    builder: (context) => MessagePanelWidget(
                      isLoading: false,
                      message:
                          context.l10n.featureOnboarding.phoneNumberUpdated,
                      messageState: MessagePanelState.positive,
                    ),
                  ),
                ),{{/enable_feature_onboarding}}
                {{#enable_pin_code}}
                 RxBlocListener<UserAccountBlocType, UserModel?>(
                  state: (bloc) => bloc.states.currentUser.skip(1),
                  listener: _onUserAccountChanged,
                 ),
              {{/enable_pin_code}}
              ]),
            ),
          ],
        ),
      );
 {{#enable_pin_code}}
  String _buildPinButtonText(
      AsyncSnapshot<UserModel?> user, BuildContext context) =>
      user.data?.hasPin == true
          ? context.l10n.libPinCode.changePin
          : context.l10n.libPinCode.createPin;

  void _onPinTileTap(BuildContext context, AsyncSnapshot<UserModel?> user) {
    if (user.data != null && user.data!.hasPin) {
      GoRouter.of(context).push(
        const UpdatePinRoute().routeLocation,
      );
      return;
    }
    GoRouter.of(context).push(
      const SetPinRoute().routeLocation,
    );
  }

  Future<void> _onUserAccountChanged(
      BuildContext context, UserModel? user) async {
    if (user != null && user.hasPin) {
      await showBlurredBottomSheet(
        context: context,
        configuration: const ModalConfiguration(safeAreaBottom: false),
        builder: (context) => MessagePanelWidget(
          message: context.l10n.libPinCode.pinUpdatedMessage,
          messageState: MessagePanelState.positiveCheck,
        ),
      );
    }
  }

  void _onNotificationStateChanged(BuildContext context, Result<bool> state) {
    if (state is ResultSuccess<bool>) {
      showBlurredBottomSheet(
        context: context,
        builder: (BuildContext context) => MessagePanelWidget(
          message: state.data.translate(context),
          messageState: MessagePanelState.positiveCheck,
        ),
      );
    }
  }
  {{/enable_pin_code}}
}