part of 'puppy_details_page.dart';

List<BlocProvider> _getProviders(Puppy puppy) => [
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
      // BlocProvider.value(value: BlocProvider.of<PuppyDetailsBloc>(context))
    ];
