// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';

import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/data_sources/remote/http_clients/api_http_client.dart';
import '../blocs/social_login_bloc.dart';
import '../data_sources/facebook_auth_data_source.dart';
import '../data_sources/facebook_credential_data_source.dart';
import '../repositories/facebook_auth_repository.dart';
import '../services/facebook_social_login_service.dart';
import '../services/social_login_service.dart';

/// [FacebookLoginWidget] provides out of the box Log in with Apple
/// functionality along with default view of the button. If you want to customize
/// the way button looks use [builder].
///
/// If an error occur a modal sheet with message will be shown. For custom error
/// handling provide [onError] callback.
class FacebookLoginWidget extends StatelessWidget {
  const FacebookLoginWidget({Key? key}) : super(key: key);

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
                builder: (context, snapshot, bloc) => snapshot.data == true
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      )
                    : SignInButton(Buttons.Facebook,
                        onPressed: () => bloc.events.login())),
          ],
        ),
      );

  List<Provider> get _dataSources => [
        Provider<FacebookAuthDataSource>(
            create: (context) =>
                FacebookAuthDataSource(context.read<ApiHttpClient>())),
        Provider<FacebookCredentialDataSource>(
            create: (context) => FacebookCredentialDataSource()),
      ];

  List<Provider> get _repositories => [
        Provider<FacebookAuthRepository>(
          create: (context) => FacebookAuthRepository(
            context.read(),
            context.read(),
            context.read(),
          ),
        )
      ];
  List<Provider> get _services => [
        Provider<SocialLoginService>(
          create: (context) => FacebookAuthService(
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
