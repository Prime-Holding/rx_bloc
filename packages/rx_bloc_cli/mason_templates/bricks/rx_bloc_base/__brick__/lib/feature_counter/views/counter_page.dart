// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/extensions/async_snapshot_extensions.dart';
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
    appBar: AppBar(
      title: Text(context.l10n.counterPageTitle),
      actions: const [ProfileAvatar()],
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildErrorListener(),
          _buildCount(),
        ],
      ),
    ),
    floatingActionButton: _buildActionButtons(context),
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

  Widget _buildCount() => RxBlocBuilder<CounterBlocType, int>(
    state: (bloc) => bloc.states.count,
    builder: (context, snapshot, bloc) => snapshot.hasData
        ? Text(
      snapshot.data.toString(),
      style: context.designSystem.typography.headline2,
    )
        : Container(),
  );

  Widget _buildActionButtons(BuildContext context) =>
      RxBlocBuilder<CounterBlocType, bool>(
        state: (bloc) => bloc.states.isLoading,
        builder: (context, loadingState, bloc) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (loadingState.isLoading)
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: CircularProgressIndicator(),
              ),
            FloatingActionButton(
              backgroundColor: loadingState.getButtonColor(context),
              onPressed: loadingState.isLoading ? null : bloc.events.increment,
              tooltip: context.l10n.increment,
              heroTag: 'increment',
              child: Icon(context.designSystem.icons.plusSign),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              backgroundColor: loadingState.getButtonColor(context),
              onPressed: loadingState.isLoading ? null : bloc.events.decrement,
              tooltip: context.l10n.decrement,
              heroTag: 'decrement',
              child: Icon(context.designSystem.icons.minusSign),
            ),
          ],
        ),
      );
}
