{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/common_services/count_down_service.dart';
import '../../base/common_services/open_mail_app_service.dart';
import '../../base/repositories/open_mail_app_repository.dart';
import '../../feature_password_reset_request/services/password_reset_request_service.dart';
import '../blocs/password_reset_confirmation_bloc.dart';
import '../services/password_reset_confirmation_service.dart';
import '../views/password_reset_confirmation_page.dart';

class PasswordResetConfirmationPageWithDependencies extends StatelessWidget {
  const PasswordResetConfirmationPageWithDependencies({
    required String email,
    super.key,
  }) : _email = email;

  final String _email;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._repositories,
          ..._services,
          ..._blocs,
        ],
        child: const PasswordResetConfirmationPage(),
      );

  List<Provider> get _repositories => [
        Provider<OpenMailAppRepository>(
          create: (context) => OpenMailAppRepository(context.read()),
        ),
      ];

  List<Provider> get _services => [
        Provider<OpenMailAppService>(
          create: (context) => OpenMailAppService(
            context.read(),
          ),
        ),
        Provider<CountDownService>(
          create: (context) => CountDownService(),
        ),
        Provider<PasswordResetRequestService>(
          create: (context) => PasswordResetRequestService(
            context.read(),
          ),
        ),
        Provider<PasswordResetConfirmationService>(
          create: (context) => PasswordResetConfirmationService(
            context.read(),
          ),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<PasswordResetConfirmationBlocType>(
          create: (context) => PasswordResetConfirmationBloc(
            _email,
            context.read(),
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
      ];
}
