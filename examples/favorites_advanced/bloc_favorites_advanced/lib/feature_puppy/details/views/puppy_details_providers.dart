part of 'puppy_details_page.dart';

List<BlocProvider> _getProviders(Puppy puppy) => [
      BlocProvider<PuppyMarkAsFavoriteBloc>(
        create: (context) => PuppyMarkAsFavoriteBloc(
          coordinatorBloc: context.read(),
          puppiesRepository: context.read(),
        ),
      ),
      BlocProvider(
        create: (context) => PuppyDetailsBloc(
          coordinatorBloc: context.read(),
          puppy: puppy,
        ),
      ),
      BlocProvider(
        create: (context) => FavoritePuppiesBloc(
          puppiesRepository: context.read(),
          coordinatorBloc: context.read(),
        ),
      ),
    ];
