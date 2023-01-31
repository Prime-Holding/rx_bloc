{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../base/common_ui_components/app_error_model_widget.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/item_model.dart';
import '../../base/routers/router.dart';
import '../../l10n/l10n.dart';
import '../../lib_navigation/blocs/navigation_bloc.dart';
import '../blocs/items_list_bloc.dart';
import '../ui_components/list_item_widget.dart';

class ItemsListPage extends StatelessWidget {
  const ItemsListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        context.l10n.deepLinkFlow.itemsListPageTitle,
      ),
    ),
    body: Column(
      children: [
        AppErrorModelWidget<ItemsListBlocType>(
          errorState: (bloc) => bloc.states.errors,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: RxResultBuilder<ItemsListBlocType, List<ItemModel>>(
              state: (bloc) => bloc.states.itemsList,
              buildError: (ctx, error, bloc) => Center(
                child: Text(
                  error.asErrorModel.toString(),
                ),
              ),
              buildLoading: (ctx, bloc) => const Center(
                child: CircularProgressIndicator(),
              ),
              buildSuccess: (ctx, items, bloc) => ListView.separated(
                padding: const EdgeInsets.all(8.0),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) =>
                    ListItemWidget(
                      item: items[index],
                      onTap: () =>
                          context.read<NavigationBlocType>().events.pushTo(
                            ItemDetailsRoute(items[index].id),
                            extra: items[index],
                          ),
                    ),
                separatorBuilder: (context, index) => const Divider(
                  height: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
