part of 'puppy_edit_page.dart';

List<BlocProvider> _getProviders(Puppy puppy) => [
      BlocProvider<PuppyMarkAsFavoriteBloc>(
        create: (context) => PuppyMarkAsFavoriteBloc(
          puppiesRepository: context.read(),
          coordinatorBloc: context.read(),
        ),
      ),
      BlocProvider<PuppyEditFormBloc>(
        create: (context) => PuppyEditFormBloc(
          repository: context.read(),
          puppy: puppy,
        ),
      ),
    ];
