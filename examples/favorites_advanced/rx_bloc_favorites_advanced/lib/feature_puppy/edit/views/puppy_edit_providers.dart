part of 'puppy_edit_page.dart';

List<RxBlocProvider> _getProviders(Puppy? puppy) => [
      RxBlocProvider<PuppyManageBlocType>(
        create: (context) => PuppyManageBloc(
          Provider.of(context, listen: false),
          Provider.of(context, listen: false),
          puppy: puppy,
          validator: PuppyValidator(),
        ),
      ),
    ];
