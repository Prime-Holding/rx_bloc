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

import '../../l10n/l10n.dart';
import '../bloc/counter_bloc.dart';
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
            children: <Widget>[
              RxBlocListener<CounterBlocType, String>(
                state: (bloc) => bloc.states.errors,
                listener: (context, errorMessage) =>
                    ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessage ?? ''),
                    behavior: SnackBarBehavior.floating,
                  ),
                ),
              ),
              RxBlocBuilder<CounterBlocType, int>(
                state: (bloc) => bloc.states.count,
                builder: (context, snapshot, bloc) => snapshot.hasData
                    ? Text(
                        snapshot.data.toString(),
                        style: Theme.of(context).textTheme.headline4,
                      )
                    : Container(),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildActionButtons(context),
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
              backgroundColor: loadingState.buttonColor,
              onPressed: loadingState.isLoading ? null : bloc.events.increment,
              tooltip: context.l10n.increment,
              child: const Icon(Icons.add),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              backgroundColor: loadingState.buttonColor,
              onPressed: loadingState.isLoading ? null : bloc.events.decrement,
              tooltip: context.l10n.decrement,
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      );
}

extension AsyncSnapshotLoadingState on AsyncSnapshot<bool> {
  /// The loading state extracted from the snapshot
  bool get isLoading => hasData && data!;

  /// The color based on the isLoading state
  Color get buttonColor => isLoading ? Colors.blueGrey : Colors.blue;
}
