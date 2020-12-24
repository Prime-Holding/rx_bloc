part of 'puppy_edit_page.dart';

extension _PuppyEditProviders on PuppyEditPage {
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
