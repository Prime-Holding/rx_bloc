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

class GoogleLoginWidget extends StatelessWidget {
  const GoogleLoginWidget({Key? key}) : super(key: key);

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
              builder: (context, loadingState, bloc) {
                final theme = MediaQuery.of(context).platformBrightness ==
                    Brightness.light;
                return SocialLoginButton(
                  isLoading: (loadingState.data ?? false) ? false : true,
                  text: context.l10n.featureLogin.googleLogin,
                  textStyle: theme
                      ? context.designSystem.typography.googleButtonTextLight
                      : context.designSystem.typography.googleButtonTextDark,
                  backgroundColor: theme
                      ? context.designSystem.colors.googleBackgroundLight
                      : context.designSystem.colors.googleBackgroundDark,
                  onPressed: (loadingState.data ?? false)
                      ? null
                      : () => bloc.events.login(),
                  child: SvgPicture.asset(
                    theme
                        ? context.designSystem.images.googleLightLogo
                        : context.designSystem.images.googleDarkLogo,
                    height: context.designSystem.spacing.xxl,
                  ),
                );
              },
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
