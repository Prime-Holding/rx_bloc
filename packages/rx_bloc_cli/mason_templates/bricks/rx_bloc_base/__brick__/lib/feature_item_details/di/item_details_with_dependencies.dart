{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/models/item_model.dart';
import '../blocs/item_details_bloc.dart';
import '../views/item_details_page.dart';

class ItemDetailsWithDependencies extends StatelessWidget {
  const ItemDetailsWithDependencies({
    required this.itemId,
    this.item,
    Key? key,
  }) : super(key: key);

  final String itemId;
  final ItemModel? item;

  List<RxBlocProvider> get _blocs => [
    RxBlocProvider<ItemDetailsBlocType>(
      create: (context) => ItemDetailsBloc(
        context.read(),
        itemId: itemId,
        item: item,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ..._blocs,
    ],
    child: ItemDetailsPage(itemId: itemId,),
  );
}
