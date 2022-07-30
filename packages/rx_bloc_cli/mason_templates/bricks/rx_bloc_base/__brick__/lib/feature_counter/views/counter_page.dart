{{> licence.dart }}

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/common_ui_components/action_button.dart';
import '../../base/common_ui_components/update_button.dart';
import '../../base/theme/design_system.dart';
import '../../feature_login/ui_components/profile_avatar.dart';
import '../../l10n/l10n.dart';
import '../blocs/counter_bloc.dart';
import '../di/counter_dependencies.dart';

class CounterPage extends StatelessWidget implements AutoRouteWrapper {
  // ignore: public_member_api_docs
  const CounterPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => MultiProvider(
        providers: CounterDependencies.of(context).providers,
        child: this,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildErrorListener(),
              RxBlocBuilder<CounterBlocType, int>(
                state: (bloc) => bloc.states.count,
                builder: (context, countState, bloc) =>
                    _buildCount(context, countState),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildActionButtons(context),
      );

  AppBar _buildAppBar(BuildContext context) => AppBar(
        title: Text(context.l10n.counterPageTitle),
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
              style: context.designSystem.typography.headline2,
            )
          : Text(
                snapshot.connectionState.toString(),
                style: context.designSystem.typography.bodyText1,
            );

  Widget _buildErrorListener() => RxBlocListener<CounterBlocType, String>(
        state: (bloc) => bloc.states.errors,
        listener: (context, errorMessage) =>
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage ?? ''),
            behavior: SnackBarBehavior.floating,
          ),
        ),
      );

  Widget _buildActionButtons(BuildContext context) =>
      RxLoadingBuilder<CounterBlocType>(
        state: (bloc) => bloc.states.isLoading,
        builder: (context, isLoading, tag, bloc) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ActionButton(
              icon: Icon(
                context.designSystem.icons.plusSign,
                color: context.designSystem.colors.iconColor,
              ),
              tooltip: context.l10n.increment,
              onPressed: bloc.events.increment,
              disabled: isLoading,
              loading: isLoading && tag == CounterBloc.tagIncrement,
            ),
            const SizedBox(width: 16),
            ActionButton(
              icon: Icon(
                context.designSystem.icons.minusSign,
                color: context.designSystem.colors.iconColor,
              ),
              tooltip: context.l10n.decrement,
              onPressed: bloc.events.decrement,
              disabled: isLoading,
              loading: isLoading && tag == CounterBloc.tagDecrement,
            ),
          ],
        ),
      );
}
