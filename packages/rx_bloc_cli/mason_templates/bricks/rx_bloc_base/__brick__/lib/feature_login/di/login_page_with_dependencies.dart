{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
{{#enable_feature_google_login}}
import 'package:google_sign_in/google_sign_in.dart';
{{/enable_feature_google_login}}
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

{{#enable_feature_google_login}}
import '../blocs/google_login_bloc.dart';
{{/enable_feature_google_login}}
import '../blocs/login_bloc.dart';
{{#enable_feature_google_login}}
import '../services/google_login_service.dart';
{{/enable_feature_google_login}}
import '../services/login_validator_service.dart';
import '../views/login_page.dart';

class LoginPageWithDependencies extends StatelessWidget {
  const LoginPageWithDependencies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
      child: const LoginPage(),
    );

  List<SingleChildWidget> get _services => [
        Provider<LoginValidatorService>(
          create: (context) => const LoginValidatorService(),
        ),
        {{#enable_feature_google_login}}
        Provider<GoogleLoginService>(
          create: (context) => GoogleLoginService(
            context.read(),
            context.read(),
            context.read(),
            context.read(),
            GoogleSignIn(),
          ),
        ),
        {{/enable_feature_google_login}}
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<LoginBlocType>(
          create: (context) => LoginBloc(
            context.read(),
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
        {{#enable_feature_google_login}}
        RxBlocProvider<GoogleLoginBlocType>(
          create: (context) => GoogleLoginBloc(
            context.read(),
            context.read(),
          ),
        ),
        {{/enable_feature_google_login}}
      ];
}
