// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/common_services/count_down_service.dart';
import '../../base/common_services/email_change_service.dart';
import '../../base/common_services/onboarding_service.dart';
import '../../base/common_services/open_mail_app_service.dart';
import '../../base/repositories/open_mail_app_repository.dart';
import '../blocs/onboarding_email_confirmation_bloc.dart';
import '../views/onboarding_email_confirmation_page.dart';

class ChangeEmailConfirmationPageWithDependencies extends StatelessWidget {
  const ChangeEmailConfirmationPageWithDependencies({
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
        child: const OnboardingEmailConfirmationPage(),
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
        Provider<OnboardingService>(
          create: (context) => EmailChangeService(
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<OnboardingEmailConfirmationBlocType>(
          create: (context) => OnboardingEmailConfirmationBloc(
            _email,
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
      ];
}
