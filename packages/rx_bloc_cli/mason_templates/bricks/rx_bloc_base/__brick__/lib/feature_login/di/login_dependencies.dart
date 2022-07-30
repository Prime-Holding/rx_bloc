{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../blocs/login_bloc.dart';

class LoginDependencies {
  LoginDependencies._(this.context);

  factory LoginDependencies.of(BuildContext context) =>
      _instance != null ? _instance! : _instance = LoginDependencies._(context);

  static LoginDependencies? _instance;

  final BuildContext context;

  List<SingleChildWidget> get providers => [
        ..._blocs,
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<LoginBlocType>(
          create: (context) => LoginBloc(
            loginUseCase: context.read(),
            coordinatorBloc: context.read(),
          ),
        ),
      ];
}
