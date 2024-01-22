{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/data_sources/remote/http_clients/api_http_client.dart';
import '../blocs/social_login_bloc.dart';
import '../data_sources/google_auth_data_source.dart';
import '../data_sources/google_credential_data_source.dart';
import '../repositories/google_auth_repository.dart';
import '../services/google_login_service.dart';
import '../services/social_login_service.dart';
import 'social_login_button.dart';

/// [GoogleLoginWidget] provides out of the box Log in with Google
/// functionality along with default view of the button.
///
/// If an error occur a modal sheet with message will be shown. For custom error
/// handling provide [onError] callback.
class GoogleLoginWidget extends StatelessWidget {
  const GoogleLoginWidget({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._dataSources,
          ..._repositories,
          ..._services,
          ..._blocs,
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppErrorModalWidget<SocialLoginBlocType>(
              errorState: (bloc) => bloc.states.errors,
            ),
            RxBlocBuilder<SocialLoginBlocType, bool>(
              state: (bloc) => bloc.states.isLoading,
              builder: (context, loadingState, bloc) => SocialLoginButton(
                isLoading: (loadingState.data ?? false) ? false : true,
                text: context.l10n.featureLogin.googleLogin,
                borderSide: BorderSide(
                  color: context.designSystem.colors.white,
                  width: 0.3,
                ),
                textStyle: context.designSystem.typography.googleButtonText,
                backgroundColor: context.designSystem.colors.googleBackground,
                progressIndicatorColor:
                    context.designSystem.colors.googleButtonText,
                onPressed: (loadingState.data ?? false)
                    ? null
                    : () => bloc.events.login(),
                child: SvgPicture.asset(
                  context.designSystem.images.googleLogo,
                  height: context.designSystem.spacing.xl,
                ),
              ),
            ),
          ],
        ),
      );

  List<Provider> get _dataSources => [
        Provider<GoogleAuthDataSource>(
          create: (context) => GoogleAuthDataSource(
            context.read<ApiHttpClient>(),
          ),
        ),
        Provider<GoogleCredentialDataSource>(
          create: (context) => GoogleCredentialDataSource(),
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
        Provider<SocialLoginService>(
          create: (context) => GoogleLoginService(
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
