import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/splash_bloc.dart';
import '../views/splash_page.dart';

/// A widget which provides the [SplashPage] with the necessary dependencies
/// injected in the widget tree.
class SplashPageWithDependencies extends StatelessWidget {
  const SplashPageWithDependencies({
    this.redirectToLocation,
    super.key,
  });

  /// The location to redirect to after the splash screen has been displayed
  final String? redirectToLocation;

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<SplashBlocType>(
          create: (context) => SplashBloc(
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
