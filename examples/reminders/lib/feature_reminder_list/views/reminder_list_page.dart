import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../../app_extensions.dart';
import '../../base/common_blocs/firebase_bloc.dart';
import '../../base/models/reminder/reminder_model.dart';
import '../../feature_reminder_manage/blocs/reminder_manage_bloc.dart';
import '../blocs/reminder_list_bloc.dart';
import '../di/reminder_list_dependencies.dart';
import '../ui_components/reminder_list_view.dart';
import 'add_reminder_dialog.dart';

class ReminderListPage extends StatelessWidget implements AutoRouteWrapper {
  const ReminderListPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => MultiProvider(
        providers: ReminderListDependencies.of(context).providers,
        child: this,
      );

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: context.designSystem.colors.backgroundListColor,
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  context.read<FirebaseBlocType>().events.logOut();
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildErrorListener(),
              Expanded(
                child: RxBlocBuilder<ReminderManageBlocType,
                    Result<ReminderModel>>(
                  state: (bloc) => bloc.states.onCreated,
                  builder: (context, onCreated, bloc) {
                    if (onCreated.data != null &&
                        onCreated.data! is ResultSuccess) {
                      final createdReminderId =
                          (onCreated.data as ResultSuccess<ReminderModel>)
                              .data
                              .id;
                      return ReminderListView(
                        createdReminderId: createdReminderId,
                      );
                    }
                    return const ReminderListView();
                  },
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () =>
                addDialog(context, context.read<ReminderManageBlocType>()),
            tooltip: 'add',
            child: const Icon(Icons.add),
          ),
        ),
      );

  Widget _buildErrorListener() => RxBlocListener<ReminderListBlocType, String>(
        state: (bloc) => bloc.states.errors,
        listener: (context, errorMessage) =>
            ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            behavior: SnackBarBehavior.floating,
          ),
        ),
      );

  Future<void> addDialog(
      BuildContext context, ReminderManageBlocType bloc) async {
    await showDialog(
      context: context,
      builder: (context) => const AddReminderDialog(),
    );
    context.read<ReminderManageBlocType>().events.setName('');
  }
}
