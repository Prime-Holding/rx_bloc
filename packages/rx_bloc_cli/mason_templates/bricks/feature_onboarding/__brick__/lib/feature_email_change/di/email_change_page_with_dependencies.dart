import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/common_services/validators/credentials_validator_service.dart';
import '../blocs/email_change_bloc.dart';
import '../services/email_change_service.dart';
import '../views/email_change_page.dart';

class EmailChangePageWithDependencies extends StatelessWidget {
  const EmailChangePageWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
          ..._blocs,
        ],
        child: const EmailChangePage(),
      );

  List<Provider> get _services => [
        Provider<CredentialsValidatorService>(
          create: (context) => const CredentialsValidatorService(),
        ),
        Provider<EmailChangeService>(
          create: (context) => EmailChangeService(
            context.read(),
          ),
        ),
      ];
  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<EmailChangeBlocType>(
          create: (context) => EmailChangeBloc(
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
      ];
}
