import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/dashboard_bloc.dart';
import '../di/dashboard_dependencies.dart';

class DashboardPage extends StatelessWidget implements AutoRouteWrapper {
  const DashboardPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => MultiProvider(
        providers: DashboardDependencies.of(context).providers,
        child: this,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(context),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildErrorListener(),
            Center(child: _buildDataContainer()),
          ],
        ),
      );

  AppBar _buildAppBar(BuildContext context) => AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: context.read<DashboardBlocType>().events.fetchData,
          ),
        ],
      );

  Widget _buildDataContainer() => RxResultBuilder<DashboardBlocType, String>(
        state: (bloc) => bloc.states.data,
        buildLoading: (ctx, bloc) => const CircularProgressIndicator(),
        buildError: (ctx, error, bloc) => Text(error.toString()),
        buildSuccess: (ctx, state, bloc) => Text(state),
      );

  Widget _buildErrorListener() => RxBlocListener<DashboardBlocType, String>(
        state: (bloc) => bloc.states.errors,
        listener: (context, errorMessage) =>
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage ?? ''),
            behavior: SnackBarBehavior.floating,
          ),
        ),
      );
}
