{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/data_sources/remote/http_clients/api_http_client.dart';

import '../blocs/social_login_bloc.dart';
import '../data_sources/apple_auth_data_source.dart';
import '../data_sources/apple_credential_data_source.dart';
import '../repositories/apple_auth_repository.dart';
import '../services/apple_social_login_service.dart';
import '../services/social_login_service.dart';

/// [AppleLoginWidget] provides out of the box Log in with Apple
/// functionality along with default view of the button. If you want to customize
/// the way button looks use [builder].
///
/// If an error occur a modal sheet with message will be shown. For custom error
/// handling provide [onError] callback.
class AppleLoginWidget extends StatelessWidget {
  const AppleLoginWidget({Key? key}) : super(key: key);

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
            AppErrorModalWidget<SocialLoginBlocType>(
              errorState: (bloc) => bloc.states.errors,
            ),
            RxBlocBuilder<SocialLoginBlocType, bool>(
              state: (bloc) => bloc.states.isLoading,
              builder: (context, snapshot, bloc) => SignInWithAppleButton(
                onPressed: () =>
                    (snapshot.data ?? false) ? null : bloc.events.login(),
              ),
            ),
          ],
        ),
      );

  List<Provider> get _dataSources => [
        Provider<AppleAuthDataSource>(
          create: (context) => AppleAuthDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),
        Provider<AppleCredentialDataSource>(
          create: (context) => AppleCredentialDataSource(),
        ),
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
        Provider<SocialLoginService>(
          create: (context) => AppleSocialLoginService(
            context.read(),
            context.read(),
          ),
        ),
      ];

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<SocialLoginBlocType>(
          create: (context) => SocialLoginBloc(
            context.read(),
            context.read(),
          ),
        ),
      ];
}
