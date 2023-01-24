{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../../base/common_blocs/user_account_bloc.dart';
import '../../base/common_ui_components/action_button.dart';
import '../../base/common_ui_components/app_error_model_widget.dart';
import '../../base/common_ui_components/update_button.dart';
import '../../base/extensions/error_model_translations.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/theme/design_system.dart';
import '../../feature_login/ui_components/profile_avatar.dart';
import '../../l10n/l10n.dart';
import '../blocs/counter_bloc.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RxBlocBuilder<CounterBlocType, int>(
                state: (bloc) => bloc.states.count,
                builder: (context, countState, bloc) =>
                    _buildCount(context, countState),
              ),
              AppErrorModelWidget<CounterBlocType>(
                errorState: (bloc) => bloc.states.errors,
              ),
              AppErrorModelWidget<UserAccountBlocType>(
                errorState: (bloc) => bloc.states.errors,
                isListeningForNavigationErrors: false,
              ),
            ],
          ),
        ),
        floatingActionButton: _buildActionButtons(context),
      );

  AppBar _buildAppBar(BuildContext context) => AppBar(
        title: Text(context.l10n.featureCounter.counterPageTitle),
        actions: [
          RxLoadingBuilder<CounterBlocType>(
            state: (bloc) => bloc.states.isLoading,
            builder: (context, isLoading, tag, bloc) => UpdateButton(
              isActive: !isLoading,
              onPressed: () => bloc.events.reload(),
            ),
          ),
          const ProfileAvatar(),
        ],
      );

  Widget _buildCount(BuildContext context, AsyncSnapshot<int> snapshot) =>
      snapshot.hasData
          ? Text(
              snapshot.data!.toString(),
              style: context.designSystem.typography.counterText,
            )
          : Text(
                snapshot.connectionState.toString(),
                style: context.designSystem.typography.h2Med16,
            );

  Widget _buildActionButtons(BuildContext context) =>
      RxLoadingBuilder<CounterBlocType>(
        state: (bloc) => bloc.states.isLoading,
        builder: (context, isLoading, tag, bloc) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ActionButton(
              icon: Icon(context.designSystem.icons.plusSign),
              tooltip: context.l10n.featureCounter.increment,
              onPressed: isLoading ? null : bloc.events.increment,
              loading: isLoading && tag == CounterBloc.tagIncrement,
            ),
            const SizedBox(width: 16),
            ActionButton(
              icon: Icon(context.designSystem.icons.minusSign),
              tooltip: context.l10n.featureCounter.decrement,
              onPressed: isLoading ? null : bloc.events.decrement,
              loading: isLoading && tag == CounterBloc.tagDecrement,
            ),
          ],
        ),
      );
}
