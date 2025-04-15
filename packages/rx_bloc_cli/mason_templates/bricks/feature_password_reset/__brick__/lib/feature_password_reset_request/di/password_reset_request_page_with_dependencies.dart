{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/common_services/validators/credentials_validator_service.dart';
import '../blocs/password_reset_request_bloc.dart';
import '../services/password_reset_request_service.dart';
import '../views/password_reset_request_page.dart';

class PasswordResetRequestPageWithDependencies extends StatelessWidget {
  const PasswordResetRequestPageWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
        child: const PasswordResetRequestPage(),
      );

  List<Provider> get _services => [
        Provider<PasswordResetRequestService>(
          create: (context) => PasswordResetRequestService(
            context.read(),
          ),
        ),
        Provider<CredentialsValidatorService>(
          create: (context) => const CredentialsValidatorService(),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<PasswordResetRequestBlocType>(
          create: (context) => PasswordResetRequestBloc(
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
      ];
}
