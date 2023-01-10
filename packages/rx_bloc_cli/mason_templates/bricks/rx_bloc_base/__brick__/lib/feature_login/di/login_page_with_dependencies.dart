{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/login_bloc.dart';
import '../views/login_page.dart';

class LoginPageWithDependencies extends StatelessWidget {
  const LoginPageWithDependencies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._blocs,
        ],
      child: const LoginPage(),
    );

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<LoginBlocType>(
          create: (context) => LoginBloc(
            loginUseCase: context.read(),
            coordinatorBloc: context.read(),
          ),
        ),
      ];
}
