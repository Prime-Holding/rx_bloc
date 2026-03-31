{{> licence.dart }}

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../base/data_sources/remote/http_clients/api_http_client.dart';
import '../../base/data_sources/remote/http_clients/plain_http_client.dart';
import '../blocs/dev_menu_bloc.dart';

class AppDevMenuGestureDetector extends StatefulWidget {
  const AppDevMenuGestureDetector({
    required this.child,
    required this.onDevMenuPresented,
    super.key,
  });

  final Widget child;
  final VoidCallback onDevMenuPresented;

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

    WidgetsBinding.instance.addPostFrameCallback((_) => _setupTalkerDioLogging());

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

  void _setupTalkerDioLogging() {
    final talker = context.read<Talker>();
    final logger = TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestHeaders: true,
        printResponseHeaders: true,
        printResponseMessage: true,
      ),
    );

    // Attach interceptor to ApiHttpClient
    context.read<ApiHttpClient>().interceptors.add(logger);

    // Attach interceptor to PlainHttpClient
    context.read<PlainHttpClient>().interceptors.add(logger);
  }
}
