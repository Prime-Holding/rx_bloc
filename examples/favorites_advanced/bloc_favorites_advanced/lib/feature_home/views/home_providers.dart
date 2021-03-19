part of 'home_page.dart';

extension _HomeProviders on HomePage {
  List<BlocProvider> _getProviders() => [
        BlocProvider<PuppiesExtraDetailsBloc>(
          create: (context) =>
              PuppiesExtraDetailsBloc(PuppiesRepository(ImagePicker())),
        ),
    BlocProvider<NavigationBarBloc>(
      create: (context) => NavigationBarBloc(),
    ),
      ];
}
