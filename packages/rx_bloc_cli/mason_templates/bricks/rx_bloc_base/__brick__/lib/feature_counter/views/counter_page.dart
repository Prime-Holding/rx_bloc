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
import 'package:test_app/base/models/count.dart';

import '../../base/extensions/async_snapshot_extensions.dart';
import '../../base/theme/design_system.dart';
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
    appBar: AppBar(title: Text(context.l10n.counterPageTitle)),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildErrorListener(),
          RxResultBuilder<CounterBlocType, Count>(
            state: (bloc) => bloc.states.counterResult,
            buildSuccess: (context, countState, bloc) => _buildCount(),
            buildLoading: (context, bloc) => _buildLoadingScreen(),
            buildError: (context, errorMessage, bloc) =>
                _buildErrorScreen(context, errorMessage, bloc),
          ),
        ],
      ),
    ),
    floatingActionButton: _buildActionButtons(context),
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

  Widget _buildLoadingScreen() =>
      const Center(child: CircularProgressIndicator());

  Widget _buildErrorScreen(
      BuildContext context,
      String errorMessage,
      CounterBlocType bloc,
      ) =>
      !errorMessage.contains('Http status error [422]')
          ? Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your API is not running. \nRun command \'bin/start_server.sh\' and try again.',
                textAlign: TextAlign.center,
                style: context.designSystem.typography.headline5,
              ),
              ElevatedButton(
                  onPressed: bloc.events.reload,
                  child: Text(
                    'RETRY',
                    style: context.designSystem.typography.buttonMain,
                  )),
            ]),
      )
          : _buildCount();

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
              child: Icon(context.designSystem.icons.plusSign),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              backgroundColor: loadingState.getButtonColor(context),
              onPressed: loadingState.isLoading ? null : bloc.events.decrement,
              tooltip: context.l10n.decrement,
              child: Icon(context.designSystem.icons.minusSign),
            ),
          ],
        ),
      );
}
