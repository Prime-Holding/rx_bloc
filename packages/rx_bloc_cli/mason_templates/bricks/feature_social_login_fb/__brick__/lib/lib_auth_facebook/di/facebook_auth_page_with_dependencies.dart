import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/data_sources/remote/http_clients/api_http_client.dart';
import '../blocs/facebook_auth_bloc.dart';
import '../data_sources/remote/facebook_auth_data_source.dart';
import '../repositories/facebook_auth_repository.dart';
import '../services/facebook_auth_service.dart';
import '../ui_components/facebook_auth_button.dart';

class FacebookAuthPageWithDependencies extends StatelessWidget {
  const FacebookAuthPageWithDependencies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._dataSources,
          ..._repositories,
          ..._services,
          ..._blocs,
        ],
        child: const FacebookAuthButton(),
      );

  List<Provider> get _dataSources => [
        Provider<FacebookAuthDataSource>(
            create: (context) =>
                FacebookAuthDataSource(context.read<ApiHttpClient>()))
      ];

  List<Provider> get _repositories => [
        Provider<FacebookAuthRepository>(
          create: (context) => FacebookAuthRepository(
            context.read(),
            context.read(),
          ),
        )
      ];
  List<Provider> get _services => [
        Provider<FacebookAuthService>(
          create: (context) => FacebookAuthService(
            context.read(),
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
      ];
  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<FacebookAuthBlocType>(
          create: (context) => FacebookAuthBloc(context.read(), context.read()),
        ),
      ];
}
