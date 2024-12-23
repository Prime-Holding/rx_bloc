{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../base/common_services/validators/credentials_validator_service.dart';
import '../blocs/login_bloc.dart';
import '../views/login_page.dart';

class LoginPageWithDependencies extends StatelessWidget {
  const LoginPageWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
      child: const LoginPage(),
    );

  List<SingleChildWidget> get _services => [
        Provider<CredentialsValidatorService>(
          create: (context) => const CredentialsValidatorService(),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<LoginBlocType>(
          create: (context) => LoginBloc(
            context.read(),
            context.read(),
            context.read(),{{#enable_feature_onboarding}}
            context.read(),{{/enable_feature_onboarding}}
          ),
        ),
      ];
}
