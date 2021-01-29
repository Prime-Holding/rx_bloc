part of 'home_page.dart';

extension _HomeProviders on HomePage {
  List<RxBlocProvider> _getProviders() => [
        RxBlocProvider<FavoritePuppiesBlocType>(
          create: (context) => FavoritePuppiesBloc(
            Provider.of(context, listen: false),
            Provider.of(context, listen: false),
          ),
        ),
        RxBlocProvider<PuppyManageBlocType>(
          create: (context) => PuppyManageBloc(
            Provider.of(context, listen: false),
            Provider.of(context, listen: false),
          ),
        ),
        RxBlocProvider<PuppiesExtraDetailsBlocType>(
          create: (context) => PuppiesExtraDetailsBloc(
            Provider.of(context, listen: false),
            Provider.of(context, listen: false),
          ),
        ),
        RxBlocProvider<NavigationBarBlocType>(
          create: (context) => NavigationBarBloc(),
        ),
      ];
}
