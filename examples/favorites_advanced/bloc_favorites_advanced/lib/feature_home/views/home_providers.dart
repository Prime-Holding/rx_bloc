part of 'home_page.dart';

List<BlocProvider> _getProviders() => [
      BlocProvider<PuppyListBloc>(
        create: (context) => PuppyListBloc(
          Provider.of(context, listen: false),
        ),
      ),
      // BlocProvider<PuppyListBloc>(
      //   create: (context) => PuppyListBloc(PuppiesRepository(
      //     ImagePicker(),
      //     ConnectivityRepository(),
      //   )),
      // ),
      BlocProvider<NavigationBarBloc>(
        create: (context) => NavigationBarBloc(),
      ),
    ];
