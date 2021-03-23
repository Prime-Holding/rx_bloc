part of 'home_page.dart';

List<BlocProvider> _getProviders() => [
      // BlocProvider<PuppiesExtraDetailsBloc>(
      //   create: (context) => PuppiesExtraDetailsBloc(
      //     PuppiesRepository(
      //       ImagePicker(),
      //       ConnectivityRepository(),
      //     ),
      //   ),
      // ),
      BlocProvider<NavigationBarBloc>(
        create: (context) => NavigationBarBloc(),
      ),
    ];
