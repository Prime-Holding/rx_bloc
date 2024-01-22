{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../blocs/enter_message_bloc.dart';
import '../services/enter_message_field_service.dart';
import '../views/enter_message_page.dart';

class EnterMessageWithDependencies extends StatelessWidget {
  const EnterMessageWithDependencies({super.key});

  List<SingleChildWidget> get _services => [
    Provider<EnterMessageFieldService>(
      create: (context) => EnterMessageFieldService(),
    ),
  ];

  List<RxBlocProvider> get _blocs => [
    RxBlocProvider<EnterMessageBlocType>(
      create: (context) => EnterMessageBloc(),
    ),
  ];

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ..._services,
      ..._blocs,
    ],
    child: const EnterMessagePage(),
  );
}
