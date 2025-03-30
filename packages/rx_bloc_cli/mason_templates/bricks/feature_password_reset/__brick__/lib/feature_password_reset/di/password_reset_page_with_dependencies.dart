{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/common_services/validators/credentials_validator_service.dart';
import '../../feature_password_reset_request/services/password_reset_request_service.dart';
import '../blocs/password_reset_bloc.dart';
import '../services/password_reset_service.dart';
import '../views/password_reset_page.dart';

class PasswordResetPageWithDependencies extends StatelessWidget {
  const PasswordResetPageWithDependencies(
    this._token,
    this._email, {
    super.key,
  });

  final String _token;
  final String _email;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
        child: const PasswordResetPage(),
      );

  List<Provider> get _services => [
        Provider<CredentialsValidatorService>(
          create: (context) => const CredentialsValidatorService(),
        ),
        Provider<PasswordResetRequestService>(
          create: (context) => PasswordResetRequestService(
            context.read(),
          ),
        ),
        Provider<PasswordResetService>(
          create: (context) => PasswordResetService(
            context.read(),
          ),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<PasswordResetBlocType>(
          create: (context) => PasswordResetBloc(
            context.read(),
            context.read(),
            context.read(),
            context.read(),
            _token,
            _email,
          ),
        ),
      ];
}
