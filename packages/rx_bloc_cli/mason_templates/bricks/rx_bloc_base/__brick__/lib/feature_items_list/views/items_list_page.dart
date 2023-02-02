{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_model_widget.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../../base/common_ui_components/primary_button.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/item_model.dart';
import '../../base/routers/router.dart';
import '../../lib_navigation/blocs/navigation_bloc.dart';
import '../blocs/items_list_bloc.dart';
import '../ui_components/list_item_widget.dart';

class ItemsListPage extends StatelessWidget {
  const ItemsListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: customAppBar(
      context,
      title: context.l10n.deepLinkFlow.itemsListPageTitle,
    ),
    body: Column(
      children: [
        AppErrorModelWidget<ItemsListBlocType>(
          errorState: (bloc) => bloc.states.errors,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(
              context.designSystem.spacing.m,
            ),
            child: RxResultBuilder<ItemsListBlocType, List<ItemModel>>(
              state: (bloc) => bloc.states.itemsList,
              buildError: (ctx, error, bloc) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    error.asErrorModel.toString(),
                  ),
                  SizedBox(height: context.designSystem.spacing.l),
                  PrimaryButton(
                    onPressed: () => bloc.events.fetchItemsList(),
                    child: Text(context.l10n.tryAgain),
                  ),
                ],
              ),
              buildLoading: (ctx, bloc) => const Center(
                child: CircularProgressIndicator(),
              ),
              buildSuccess: (ctx, items, bloc) => ListView.separated(
                padding: EdgeInsets.all(
                  context.designSystem.spacing.xs,
                ),
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
                separatorBuilder: (context, index) => Divider(
                  height: context.designSystem.spacing.l,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
