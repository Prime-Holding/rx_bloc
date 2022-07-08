import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/common_blocs/firebase_bloc.dart';
import '../ui_components/login_text.dart';

class FacebookLoginPage extends StatefulWidget {
  const FacebookLoginPage({Key? key}) : super(key: key);

  @override
  _FacebookLoginPageState createState() => _FacebookLoginPageState();
}

class _FacebookLoginPageState extends State<FacebookLoginPage> {
  static const _accountExistsWithDifferentCredential =
      'account-exists-with-different-credential';
  static const _invalidCredential = 'invalid-credential';
  static const _operationNotAllowedException = 'operation-not-allowed';
  static const _userDisabled = 'user-disabled';
  static const _userNotFoundException = 'user-not-found';

  Future<void> _loginWithFacebook() async {
    try {
      // Trigger the sign-in flow
      // final facebookLoginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      // final facebookAuthCredential = FacebookAuthProvider.credential(
      //     facebookLoginResult.accessToken!.token);

      // final data = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

      // print('${data.credential}');
      // print('${data.user?.uid}');
      // print('${data.credential}');
      /// todo when I login with a user if his collection is empty, create a new
      /// collection with 100 elements
      await context.router.replace(const NavigationRoute());
    } on FirebaseAuthException catch (e) {
      var content = '';
      switch (e.code) {
        case _accountExistsWithDifferentCredential:
          content = context.l10n.accountExistsWithDifferentSignInProvider;
          break;
        case _invalidCredential:
          content = context.l10n.unknownError;
          break;
        case _operationNotAllowedException:
          content = context.l10n.operationNotAllowed;
          break;
        case _userDisabled:
          content = context.l10n.userIsDisabled;
          break;
        case _userNotFoundException:
          content = context.l10n.userNotFound;
          break;
      }

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.l10n.logInWithFacebookFailed),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                context.router.pop();
              },
              child: Text(context.l10n.ok),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _loggedInListener();
    // _loggedInBuilder();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoginText(text: context.l10n.reminders),
            const SizedBox(height: 5),
            LoginText(text: context.l10n.logIn),
            _Button(
              text: context.l10n.logInAsAnonymous,
              color: Colors.blueGrey,
              onPressed: () {
                context.router.replace(const NavigationRoute());
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => context.read<FirebaseBlocType>().events.logIn(),
            ),
            MaterialButton(
              color: Colors.amber,
              onPressed: () => context.read<FirebaseBlocType>().events.logIn,
            ),
            ///UNCOMMENt
            _buildLoggedInRxBlocBuilder(),
            _Button(
              text: context.l10n.logInWithFacebook,
              color: Colors.blue,
              onPressed: () => context.read<FirebaseBlocType>().events.logIn,
              // onPressed: () {
              ///todo is the logins state was successful got to navigationroute
              // _loginWithFacebook();
              // print('LoggedDDDDD');
              // context.read<FirebaseBlocType>().events.logIn();
              //
              // },
            ),
          ],
        ),
      ),
    );
  }

  RxBlocBuilder<FirebaseBlocType, bool> _buildLoggedInRxBlocBuilder() {
    return RxBlocBuilder<FirebaseBlocType, bool>(
            state: (bloc) => bloc.states.loggedIn,
            builder: (context, snap, _) {
              print('LOGGEDBuilder');
              if(snap.hasData && snap.data == true) {
                context.router.replace(const NavigationRoute());
                return const Text('LOGGED');
              }
              return const Text('NOT LOGGED');
            },
          );
  }

  Widget _loggedInBuilder() {
    // RxBlocListener<FirebaseBlocType,bool>(
    return RxBlocBuilder<FirebaseBlocType, bool>(
      state: (bloc) => bloc.states.loggedIn,
      // listener: (context, snapshot) {
      builder: (context, snapshot, bloc) {
        print('BUILDER');

        // if(snapshot != null && snapshot == true) {
        context.router.replace(const NavigationRoute());
        // }
        return Container();
      },
    );
  }

  void _loggedInListener() {
    RxBlocListener<FirebaseBlocType, bool>(
      // RxBlocBuilder<FirebaseBlocType,bool>(
      state: (bloc) => bloc.states.loggedIn,
      listener: (context, snapshot) {
        print('LISTENER');
        // builder: (context, snapshot, bloc) {
        if (snapshot != null && snapshot == true) {
          context.router.replace(const NavigationRoute());
        }
        // return Container();
      },
    );
  }
}

class _Button extends StatelessWidget {
  final Color color;
  final String text;
  final VoidCallback onPressed;

  const _Button({
    required this.color,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      child: GestureDetector(
        onTap: () {
          onPressed();
        },
        child: Container(
          height: 55,
          decoration: BoxDecoration(
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(text, style: TextStyle(color: color, fontSize: 18)),
                    const SizedBox(width: 35),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
