{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/enter_message_bloc.dart';
import '../views/enter_message_page.dart';

class EnterMessageWithDependencies extends StatelessWidget {
  const EnterMessageWithDependencies({
    Key? key,
  }) : super(key: key);

  List<RxBlocProvider> get _blocs => [
    RxBlocProvider<EnterMessageBlocType>(
      create: (context) => EnterMessageBloc(),
    ),
  ];

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ..._blocs,
    ],
    child: const EnterMessagePage(),
  );
}
