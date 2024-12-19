{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart'; {{#enable_pin_code}}
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart'; {{/enable_pin_code}}
import '../blocs/profile_bloc.dart'; {{#enable_pin_code}}
import '../repositories/biometrics_auth_repository.dart';
import '../services/biometrics_auth_service.dart'; {{/enable_pin_code}}
import '../views/profile_page.dart';

class ProfilePageWithDependencies extends StatelessWidget {
  const ProfilePageWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [ {{#enable_pin_code}}
          ..._repositories,
          ..._services,{{/enable_pin_code}}
          ..._blocs,
        ],
        child: const ProfilePage(),
      ); {{#enable_pin_code}}
  List<Provider> get _repositories => [
        Provider<BiometricsAuthRepository>(
          create: (context) => BiometricsAuthRepository(
            PinBiometricsAuthDataSource(),
          ),
        ),
      ];

  List<Provider> get _services => [
        Provider<BiometricsAuthService>(
          create: (context) => BiometricsAuthService(
            context.read<BiometricsAuthRepository>(),
          ),
        ),
      ]; {{/enable_pin_code}}

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<ProfileBlocType>(
          create: (context) => ProfileBloc(
            context.read(), {{#enable_pin_code}}
            context.read(), {{/enable_pin_code}}
          ),
        ),
      ];
}
