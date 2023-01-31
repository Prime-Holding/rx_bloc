{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../../app_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../blocs/splash_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: RxBlocBuilder<SplashBlocType, ErrorModel>(
      state: (bloc) => bloc.states.errors,
      builder: (state, snapshot, bloc) =>
      snapshot.hasData && snapshot.data != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(snapshot.data!.toString()),
            ElevatedButton(
              onPressed: () => bloc.events.initializeApp(),
              child: Text(context.l10n.tryAgain),
            )
          ],
        ),
      )
          : const SizedBox(),
    ),
  );
}
