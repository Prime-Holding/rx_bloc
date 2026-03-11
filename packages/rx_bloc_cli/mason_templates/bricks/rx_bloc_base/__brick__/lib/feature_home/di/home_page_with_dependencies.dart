import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

{{#enable_in_app_notifications}}
import '../../feature_in_app_notifications/blocs/unread_notifications_bloc.dart';{{/enable_in_app_notifications}}
import '../views/home_page.dart';

class HomePageWithDependencies extends StatelessWidget {
  const HomePageWithDependencies({
    required this.currentIndex,
    required this.branchNavigators,
    required this.onNavigationItemSelected,
    super.key,
  });

  final int currentIndex;
  final List<Widget> branchNavigators;
  final void Function(int) onNavigationItemSelected;

  @override
  Widget build(BuildContext context) {
    final providers = _providers;

    if (providers.isEmpty) {
      return HomePage(
        currentIndex: currentIndex,
        branchNavigators: branchNavigators,
        onNavigationItemSelected: onNavigationItemSelected,
      );
    }

    return MultiProvider(
      providers: _providers,
      child: HomePage(
        currentIndex: currentIndex,
        branchNavigators: branchNavigators,
        onNavigationItemSelected: onNavigationItemSelected,
      ),
    );
  }

  List<SingleChildWidget> get _providers => [ {{#enable_in_app_notifications}}
    RxBlocProvider<UnreadNotificationsBlocType>(
      create: (context) => UnreadNotificationsBloc(
        context.read(),
        context.read(),
      ),
    ), {{/enable_in_app_notifications}}
  ];

}

