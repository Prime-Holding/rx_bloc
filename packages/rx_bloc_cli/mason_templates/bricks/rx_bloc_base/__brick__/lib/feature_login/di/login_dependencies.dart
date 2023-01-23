{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../blocs/login_bloc.dart';
import '../services/login_validator_service.dart';

class LoginDependencies {
  LoginDependencies._(this.context);

  factory LoginDependencies.from(BuildContext context) =>
      LoginDependencies._(context);

  final BuildContext context;

  List<SingleChildWidget> get providers => [
        ..._services,
        ..._blocs,
      ];

  List<SingleChildWidget> get _services => [
        Provider<LoginValidatorService>(
          create: (context) => const LoginValidatorService(),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<LoginBlocType>(
          create: (context) => LoginBloc(
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
      ];
}
