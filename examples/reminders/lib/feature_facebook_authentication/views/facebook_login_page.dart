import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/common_blocs/firebase_bloc.dart';
import '../ui_components/login_button.dart';
import '../ui_components/login_text.dart';

class FacebookLoginPage extends StatefulWidget {
  const FacebookLoginPage({super.key});

  @override
  State<FacebookLoginPage> createState() => _FacebookLoginPageState();
}

class _FacebookLoginPageState extends State<FacebookLoginPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: SizedBox(
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LoginText(text: context.l10n.reminders),
                const SizedBox(height: 5),
                LoginText(text: context.l10n.logIn),
                _buildButtonsArea(context),
              ],
            ),
          ),
        ),
      );

  Widget _buildFirebaseLoginErrorListener() =>
      RxBlocListener<FirebaseBlocType, String>(
        state: (bloc) => bloc.states.errors,
        listener: (context, errorMessage) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      );

  Widget _buildButtonsArea(BuildContext context) =>
      RxLoadingBuilder<FirebaseBlocType>(
        state: (bloc) => bloc.states.isLoading,
        builder: (context, isLoading, tag, bloc) => Column(
          children: [
            RxBlocListener<FirebaseBlocType, bool>(
              state: (bloc) => bloc.states.loggedIn,
              listener: (context, logIn) {
                if (logIn == true) {
                  context.router.replace(const NavigationRoute());
                }
              },
            ),
            _buildFirebaseLoginErrorListener(),
            LoginButton(
              text: context.l10n.logInAsAnonymous,
              color: Colors.blueGrey,
              onPressed: () {
                context.read<FirebaseBlocType>().events.logIn(anonymous: true);
              },
              loading: isLoading && tag == FirebaseBloc.tagAnonymous,
            ),
            LoginButton(
              text: context.l10n.logInWithFacebook,
              color: Colors.blue,
              onPressed: () => context
                  .read<FirebaseBlocType>()
                  .events
                  .logIn(anonymous: false),
              loading: isLoading && tag == FirebaseBloc.tagFacebook,
            ),
          ],
        ),
      );
}
