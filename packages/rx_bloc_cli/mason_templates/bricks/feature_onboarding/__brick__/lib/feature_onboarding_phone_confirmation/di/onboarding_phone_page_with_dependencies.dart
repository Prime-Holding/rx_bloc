import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/models/country_code_model.dart';
import '../blocs/onboarding_phone_bloc.dart';
import '../repositories/search_country_code_repository.dart';
import '../services/phone_number_validator_service.dart';
import '../services/search_country_code_service.dart';
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
        Provider<SearchCountryCodeRepository>(
          create: (context) => SearchCountryCodeRepository(
            context.read(),
          ),
        ),
      ];

  List<Provider> get _services => [
        Provider<PhoneNumberValidatorService>(
          create: (context) => const PhoneNumberValidatorService(),
        ),
        Provider<SearchCountryCodeService>(
          create: (context) => SearchCountryCodeService(
            context.read(),
          ),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<OnboardingPhoneBlocType>(
          create: (context) => OnboardingPhoneBloc(
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
      ];
}
