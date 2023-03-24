{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/data_sources/remote/http_clients/api_http_client.dart';
import '../blocs/apple_login_bloc.dart';
import '../data_sources/apple_auth_data_source.dart';
import '../data_sources/apple_credential_data_source.dart';
import '../repositories/apple_auth_repository.dart';
import '../services/apple_social_login_service.dart';
import '../ui_components/apple_login_button.dart';

/// [AppleLoginButtonWithDependencies] provides out of the box Log in with Apple
/// functionality along with default view of the button. If you want to customize
/// the way button looks use [builder].
///
/// If an error occur a modal sheet with message will be shown. For custom error
/// handling provide [onError] callback.
class AppleLoginButtonWithDependencies extends StatelessWidget {
  const AppleLoginButtonWithDependencies({Key? key}) : super(key: key);

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
            AppErrorModalWidget<AppleLoginBlocType>(
              errorState: (bloc) => bloc.states.errors,
            ),
            const AppleLoginButton(),
          ],
        ),
      );

  List<Provider> get _dataSources => [
        Provider<AppleAuthDataSource>(
            create: (context) =>
                AppleAuthDataSource(context.read<ApiHttpClient>())),
        Provider<AppleCredentialDataSource>(
            create: (context) => AppleCredentialDataSource()),
      ];
  List<Provider> get _repositories => [
        Provider<AppleAuthRepository>(
          create: (context) => AppleAuthRepository(
            context.read(),
            context.read(),
            context.read(),
          ),
        ),
      ];
  List<Provider> get _services => [
        Provider<AppleSocialLoginService>(
          create: (context) => AppleSocialLoginService(
            context.read(),
            context.read(),
          ),
        ),
      ];
  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<AppleLoginBlocType>(
          create: (context) => AppleLoginBloc(
            context.read(),
            context.read(),
          ),
        ),
      ];
}
