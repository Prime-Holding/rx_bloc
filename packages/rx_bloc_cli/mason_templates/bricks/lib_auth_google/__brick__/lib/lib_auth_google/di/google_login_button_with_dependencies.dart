import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/data_sources/remote/http_clients/api_http_client.dart';
import '../blocs/google_login_bloc.dart';
import '../data_sources/remote/google_auth_data_source.dart';
import '../repositories/google_auth_repository.dart';
import '../services/google_login_service.dart';
import '../ui_components/google_login_button.dart';

class GoogleLoginButtonWithDependencies extends StatelessWidget {
  const GoogleLoginButtonWithDependencies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._dataSources,
          ..._repositories,
          ..._services,
          ..._blocs,
        ],
        child: Column(
          children: [
            AppErrorModalWidget<GoogleLoginBlocType>(
              errorState: (bloc) => bloc.states.errors,
            ),
            const GoogleLoginButton(),
          ],
        ),
      );

  List<Provider> get _dataSources => [
        Provider<GoogleAuthDataSource>(
          create: (context) => GoogleAuthDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),
      ];

  List<Provider> get _repositories => [
        Provider<GoogleAuthRepository>(
          create: (context) => GoogleAuthRepository(
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
      ];

  List<Provider> get _services => [
        Provider<GoogleLoginService>(
          create: (context) => GoogleLoginService(
            context.read(),
            context.read(),
          ),
        ),
      ];
  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<GoogleLoginBlocType>(
          create: (context) => GoogleLoginBloc(
            context.read(),
            context.read(),
          ),
        ),
      ];
}
