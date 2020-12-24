part of 'puppy_details_page.dart';

extension _PuppyDetailsProviders on PuppyDetailsPage {
  List<RxBlocProvider> _getProviders() => [
        RxBlocProvider<PuppyListBlocType>(
          create: (context) => PuppyListBloc(
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
      ];
}
