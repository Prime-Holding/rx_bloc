// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:widget_toolkit/models.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../lib_change_language/bloc/change_language_bloc.dart';
import '../../lib_change_language/extensions/language_model_extensions.dart';
import '../../lib_change_language/ui_components/language_picker_button.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../blocs/profile_bloc.dart';
import '../extensions/push_notifications_extensions.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    context.read<ProfileBlocType>().events.loadNotificationsSettings();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
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
            ),
            LanguagePickerButton(
              onChanged: (language) => context
                  .read<ChangeLanguageBlocType>()
                  .events
                  .setCurrentLanguage(language),
              padding: context.designSystem.spacing.xl0,
              buttonText:
                  context.l10n.featureProfile.profilePageChangeLanguageButton,
              translate: (model) => model.asText(context),
            ),
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
          ],
        ),
      );
}

extension _StringX on String {
  bool get isLoadingSubscription =>
      this == ProfileBloc.tagNotificationUnsubscribe ||
      this == ProfileBloc.tagNotificationSubscribe;
}
