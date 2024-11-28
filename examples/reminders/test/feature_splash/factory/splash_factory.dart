import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:reminders/feature_splash/blocs/splash_bloc.dart';
import 'package:reminders/feature_splash/views/splash_page.dart';
import '../mock/splash_mock.dart';

/// Change the parameters according the the needs of the test
Widget splashFactory({
  bool? isLoading,
  String? errors,
}) =>
    Scaffold(
      body: MultiProvider(providers: [
        RxBlocProvider<SplashBlocType>.value(
          value: splashMockFactory(
            isLoading: isLoading ?? false,
            errors: errors,
          ),
        ),
      ], child: const SplashPage()),
    );
