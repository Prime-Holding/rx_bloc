{{> licence.dart }}

import 'package:flutter/material.dart';

import '../../app_extensions.dart';
import '../blocs/social_login_bloc.dart';
import 'social_login_button.dart';

class GoogleSocialButton extends StatelessWidget {
  const GoogleSocialButton({
    super.key,
    required this.loadingState,
    required this.bloc,
    required this.backgroundColor,
    required this.assetImage,
    required this.textStyle,
  });
  final AsyncSnapshot loadingState;
  final SocialLoginBlocType bloc;
  final Color backgroundColor;
  final AssetImage assetImage;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return SocialLoginButton(
      isLoading: (loadingState.data ?? false) ? false : true,
      text: context.l10n.featureLogin.googleLogin,
      textStyle: textStyle,
      backgroundColor: backgroundColor,
      innerPadding: const EdgeInsets.all(0),
      onPressed:
          (loadingState.data ?? false) ? null : () => bloc.events.login(),
      child: Image(
        image: assetImage,
        height: context.designSystem.spacing.xxl2,
      ),
    );
  }
}
