import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/onboarding_phone_bloc.dart';
import '../models/country_code.dart';
import '../repositories/search_country_code_repository.dart';
import '../repositories/user_repository.dart';
import '../services/search_country_code_service.dart';
import '../services/user_service.dart';
import '../views/onboarding_phone_page.dart';

class OnboardingPhonePageWithDependencies extends StatelessWidget {
  const OnboardingPhonePageWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._repositories,
          ..._services,
          ..._blocs,
        ],
        child: Builder(builder: (context) => const OnboardingPhonePage()),
      );

  List<Provider> get _repositories => [
        Provider<SearchCountryCodeRepository<CountryCodeModel>>(
          create: (context) => SearchCountryCodeRepository<CountryCodeModel>(),
        ),
        Provider<UserRepository>(
          create: (context) => UserRepository(context.read()),
        ),
      ];

  List<Provider> get _services => [
        Provider<SearchCountryCodeService>(
          create: (context) => SearchCountryCodeService(
            context.read(),
          ),
        ),
        Provider<UserService>(
          create: (context) => UserService(
            context.read(),
            context.read(),
          ),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<OnboardingPhoneBlocType>(
          create: (context) => OnboardingPhoneBloc(
            context.read(),
          ),
        ),
      ];
}
