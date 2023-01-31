{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../blocs/items_list_bloc.dart';
import '../views/items_list_page.dart';

class ItemsListWithDependencies extends StatelessWidget {
  const ItemsListWithDependencies({Key? key}) : super(key: key);

  List<RxBlocProvider> get _blocs => [
    RxBlocProvider<ItemsListBlocType>(
      create: (context) => ItemsListBloc(
        context.read(),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ..._blocs,
    ],
    child: const ItemsListPage(),
  );
}
