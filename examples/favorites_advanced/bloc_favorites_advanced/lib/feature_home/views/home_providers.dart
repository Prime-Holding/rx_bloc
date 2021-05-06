part of 'home_page.dart';

List<BlocProvider> _getProviders() => [
      BlocProvider<FavoritePuppiesBloc>(
        create: (context) => FavoritePuppiesBloc(
          coordinatorBloc: context.read(),
          puppiesRepository: context.read(),
        ),
      ),
      BlocProvider<PuppyManageBloc>(
        create: (context) => PuppyManageBloc(
          coordinatorBloc: context.read(),
          puppiesRepository: context.read(),
        ),
      ),
      BlocProvider<PuppyListBloc>(
        create: (context) => PuppyListBloc(
          coordinatorBloc: context.read(),
          repository: context.read(),
          // context.read<FavoritePuppiesBloc>(),
        ),
      ),
      BlocProvider<PuppiesExtraDetailsBloc>(
        create: (context) => PuppiesExtraDetailsBloc(
          repository: context.read(),
          coordinatorBloc: context.read(),
        ),
      ),
      BlocProvider<NavigationBarBloc>(
        create: (context) => NavigationBarBloc(),
      ),
      // BlocProvider<PuppyDetailsBloc>(
      //     create: (context) => PuppyDetailsBloc(
      //     coordinatorBloc: context.read(), ))
    ];
