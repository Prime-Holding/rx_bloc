// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/splash_bloc.dart';
import '../views/splash_page.dart';

class SplashPageWithDependencies extends StatelessWidget {
  const SplashPageWithDependencies({
    this.redirectToLocation,
    super.key,
  });

  final String? redirectToLocation;

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<SplashBlocType>(
          create: (context) => SplashBloc(
            context.read(),
            context.read(),
            redirectLocation: redirectToLocation,
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._blocs,
        ],
        child: const SplashPage(),
      );
}
