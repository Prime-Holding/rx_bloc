part of 'puppy_details_page.dart';

extension _PuppyDetailsProviders on PuppyDetailsPage {
  List<RxBlocProvider> _getProviders(Puppy puppy) => [
        RxBlocProvider<PuppyManageBlocType>(
          create: (context) => PuppyManageBloc(
            Provider.of(context, listen: false),
            Provider.of(context, listen: false),
            puppy: puppy,
          ),
        ),
        RxBlocProvider<PuppiesExtraDetailsBlocType>(
          create: (context) => PuppiesExtraDetailsBloc(
            Provider.of(context, listen: false),
            Provider.of(context, listen: false),
          ),
        ),
      ];
}
