import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../blocs/reminder_list_bloc.dart';
import '../di/reminder_list_dependencies.dart';
import '../ui_components/reminder_list_view.dart';
import 'add_reminder_dialog.dart';

class ReminderListPage extends StatelessWidget implements AutoRouteWrapper {
  const ReminderListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => MultiProvider(
        providers: ReminderListDependencies.of(context).providers,
        child: this,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(context),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildErrorListener(),
            const Expanded(
              child: ReminderListView(),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => addDialog(context),
          tooltip: 'add',
          child: const Icon(Icons.add),
        ),
      );

  AppBar _buildAppBar(BuildContext context) => AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context
                .read<ReminderListBlocType>()
                .events
                .loadPage(reset: true),
          ),
        ],
      );

  Widget _buildErrorListener() => RxBlocListener<ReminderListBlocType, String>(
        state: (bloc) => bloc.states.errors,
        listener: (context, errorMessage) =>
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage ?? ''),
            behavior: SnackBarBehavior.floating,
          ),
        ),
      );

  Future<void> addDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return const AddReminderDialog();
        });
  }
}
