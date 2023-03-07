import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/reminder_list_bloc.dart';
import '../services/reminder_list_service.dart';
import '../views/reminder_list_page.dart';

class ReminderListPageWithDependencies extends StatelessWidget {
  const ReminderListPageWithDependencies({Key? key}) : super(key: key);

  List<Provider> get _services => [
        Provider<ReminderListService>(
          create: (context) => ReminderListService(),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<ReminderListBlocType>(
          create: (context) => ReminderListBloc(
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
        child: const ReminderListPage(),
      );
}
