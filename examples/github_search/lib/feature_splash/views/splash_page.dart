// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_widget.dart';
import '../../base/common_ui_components/app_loading_indicator.dart';
import '../../base/extensions/async_snapshot_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../blocs/splash_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RxBlocBuilder<SplashBlocType, bool>(
              state: (bloc) => bloc.states.isLoading,
              builder: (state, loading, bloc) => loading.isLoading
                  ? Expanded(
                      child: Center(
                        child: AppLoadingIndicator.taskValue(
                          context,
                          color: context.designSystem.colors.primaryColor,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
            RxBlocBuilder<SplashBlocType, ErrorModel?>(
              state: (bloc) => bloc.states.errors,
              builder: (state, snapshot, bloc) =>
                  snapshot.hasData && snapshot.data != null
                      ? Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.designSystem.spacing.l,
                            ),
                            child: AppErrorWidget(
                              error: snapshot.data!,
                              onTabRetry: () => bloc.events.initializeApp(),
                            ),
                          ),
                        )
                      : const SizedBox(),
            )
          ],
        ),
      );
}
