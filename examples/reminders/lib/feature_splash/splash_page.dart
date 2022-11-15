import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../app_extensions.dart';
import '../base/common_blocs/firebase_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const _logoPath = 'assets/images/prime_logo.jpeg';

  @override
  void initState() {
    super.initState();
    startSplashTimer();
  }

  Future<Timer> startSplashTimer() async {
    var duration = const Duration(seconds: 1);
    return Timer(duration, _checkIfUserIsLoggedIn);
  }

  void _checkIfUserIsLoggedIn() {
    context.read<FirebaseBlocType>().events.checkIfUserIsLoggedIn();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: RxBlocListener<FirebaseBlocType, bool>(
          state: (bloc) => bloc.states.isUserLoggedIn,
          listener: _navigateToADifferentRoute,
          child: Center(
            child: SizedBox(
              height: 200,
              child: Column(
                children: const [
                  Image(
                    image: AssetImage(_logoPath),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void _navigateToADifferentRoute(
    BuildContext context,
    bool? isUserLoggedIn,
  ) {
    if (isUserLoggedIn == false) {
      context.router.replace(const FacebookLoginRoute());
    } else if (isUserLoggedIn == true) {
      context.router.replace(const NavigationRoute());
    }
  }
}
