part of 'home_page.dart';

List<BlocProvider> _getProviders() => [
      BlocProvider<FavoritePuppiesBloc>(
        create: (context) => FavoritePuppiesBloc(
          context.read(),
        ),
      ),
      BlocProvider<PuppyListBloc>(
        create: (context) => PuppyListBloc(
          context.read(),
          context.read(),
        ),
      ),
      // BlocProvider<FavoritePuppiesBloc>(
      //   create: (context) => FavoritePuppiesBloc(
      //     Provider.of(context, listen: false),
      //   ),
      // ),
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
