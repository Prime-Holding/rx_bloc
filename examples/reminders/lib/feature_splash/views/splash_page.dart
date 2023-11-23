// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../../base/common_ui_components/app_error_widget.dart';
import '../../base/extensions/async_snapshot_extensions.dart';
import '../blocs/splash_bloc.dart';

/// Splash page presented when the app is launched
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const _logoPath = 'assets/images/prime_logo.jpeg';

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RxBlocBuilder<SplashBlocType, bool>(
              state: (bloc) => bloc.states.isLoading,
              builder: (state, loading, bloc) => loading.isLoading
                  ? const Expanded(
                      child: Center(
                        child: SizedBox(
                          height: 200,
                          child: Column(
                            children: [
                              Image(
                                image: AssetImage(_logoPath),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
            RxBlocBuilder<SplashBlocType, String?>(
              state: (bloc) => bloc.states.errors,
              builder: (state, snapshot, bloc) =>
                  snapshot.hasData && snapshot.data != null
                      ? Expanded(
                          child: AppErrorWidget(
                            error: snapshot.data!,
                            onTabRetry: () => bloc.events.initializeApp(),
                          ),
                        )
                      : const SizedBox(),
            )
          ],
        ),
      );
}
