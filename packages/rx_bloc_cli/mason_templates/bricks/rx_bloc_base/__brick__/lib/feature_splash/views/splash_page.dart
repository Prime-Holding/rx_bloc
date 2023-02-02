{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../../base/common_ui_components/app_error_card_component.dart';
import '../../base/models/errors/error_model.dart';
import '../blocs/splash_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: RxBlocBuilder<SplashBlocType, ErrorModel>(
            state: (bloc) => bloc.states.errors,
            builder: (state, snapshot, bloc) =>
            snapshot.hasData && snapshot.data != null
                ? AppErrorCardComponent(
              error: snapshot.data!,
              onTabRetry: () => bloc.events.initializeApp(),
            )
                : const SizedBox(),
          ),
        ),
      ],
    ),
  );
}
