{{> licence.dart }}

import 'package:alice/alice.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/data_sources/remote/http_clients/api_http_client.dart';
import '../../base/data_sources/remote/http_clients/plain_http_client.dart';
import '../../lib_router/router.dart';
import '../blocs/dev_menu_bloc.dart';
import '../di/dev_menu_dependencies.dart';
import 'dev_menu_bottom_sheet.dart';

class AppDevMenuGestureDetector extends StatefulWidget {
  const AppDevMenuGestureDetector({
    required this.child,
    required this.onDevMenuPresented,
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onDevMenuPresented;
  final GlobalKey<NavigatorState>? navigatorKey;

  static Widget withDependencies(
    BuildContext context,
    GlobalKey<NavigatorState> navigatorKey, {
    required Widget child,
  }) =>
      MultiProvider(
        providers: DevMenuDependencies.from(context).providers,
        child: AppDevMenuGestureDetector(
          onDevMenuPresented: () {
            showAppDevMenuBottomSheet(
              context.read<AppRouter>().rootNavigatorKey.currentContext!,
            );
          },
          navigatorKey: navigatorKey,
          child: child,
        ),
      );

  @override
  State<AppDevMenuGestureDetector> createState() =>
      _AppDevMenuGestureDetectorState();
}

class _AppDevMenuGestureDetectorState extends State<AppDevMenuGestureDetector> {
  final _compositeSubscription = CompositeSubscription();

  @override
  void initState() {
    context
        .read<DevMenuBlocType>()
        .states
        .onDevMenuPresented
        .listen((_) => widget.onDevMenuPresented())
        .addTo(_compositeSubscription);

    WidgetsBinding.instance.addPostFrameCallback((_) => _setupAlice());

    super.initState();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.read<DevMenuBlocType>().events.tap(),
        child: widget.child,
      );

  @override
  void dispose() {
    _compositeSubscription.dispose();
    super.dispose();
  }

  void _setupAlice() {
    Alice alice = context.read<Alice>();

    //Set navigator key
    alice.setNavigatorKey(widget.navigatorKey!);

    // Attach interceptor to ApiHttpClient
    context.read<ApiHttpClient>().interceptors.add(alice.getDioInterceptor());

    // Attach interceptor to PlainHttpClient
    context.read<PlainHttpClient>().interceptors.add(alice.getDioInterceptor());
  }
}
