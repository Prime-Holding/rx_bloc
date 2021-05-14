part of 'puppy_edit_page.dart';

List<BlocProvider> _getProviders(Puppy? puppy) => [
      BlocProvider<PuppyManageBloc>(
        create: (context) => PuppyManageBloc(
          puppiesRepository: context.read(),
          coordinatorBloc: context.read(),
          // puppy: puppy,
          // validator: const PuppyValidator(),
        ),
      ),
      BlocProvider<PuppyEditFormBloc>(
        create: (context) => PuppyEditFormBloc(),
      ),
    ];
