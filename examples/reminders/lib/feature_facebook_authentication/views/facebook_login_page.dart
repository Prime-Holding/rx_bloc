import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../../app_extensions.dart';
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
      final facebookLoginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final facebookAuthCredential = FacebookAuthProvider.credential(
          facebookLoginResult.accessToken!.token);

      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
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
            _Button(
              text: context.l10n.logInWithFacebook,
              color: Colors.blue,
              onPressed: () {
                _loginWithFacebook();
              },
            ),
          ],
        ),
      ),
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
