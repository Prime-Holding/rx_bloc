{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/common_ui_components/app_error_widget.dart';
import '../../base/common_ui_components/app_loading_indicator.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../../base/models/item_model.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../blocs/items_list_bloc.dart';
import '../ui_components/enter_message_button.dart';
import '../ui_components/list_item_widget.dart';

class ItemsListPage extends StatelessWidget {
  const ItemsListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: customAppBar(
          context,
          title: context.l10n.itemsFlow.itemsListPageTitle,
          actions: [
            RxLoadingBuilder<ItemsListBlocType>(
              state: (bloc) => bloc.states.isLoading,
              builder: (context, isLoading, tag, bloc) => EnterMessageButton(
                isActive: !isLoading,
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppErrorModalWidget<ItemsListBlocType>(
              errorState: (bloc) => bloc.states.errors,
            ),
            RxBlocListener<ItemsListBlocType, String>(
              state: (bloc) => bloc.states.message,
              condition: (old, current) =>
                  (old != current && current.isNotEmpty),
              listener: _onMessageReceived,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(
                  context.designSystem.spacing.m,
                ),
                child: RxResultBuilder<ItemsListBlocType, List<ItemModel>>(
                  state: (bloc) => bloc.states.itemsList,
                  buildError: (ctx, error, bloc) => AppErrorWidget(
                    error: error,
                    onTabRetry: () => bloc.events.fetchItemsList(),
                  ),
                  buildLoading: (ctx, bloc) => Center(
                    child: AppLoadingIndicator.taskValue(context),
                  ),
                  buildSuccess: (ctx, items, bloc) => ListView.separated(
                    padding: EdgeInsets.all(
                      context.designSystem.spacing.xs,
                    ),
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) =>
                        ListItemWidget(
                      item: items[index],
                      onTap: () => context.read<RouterBlocType>().events.pushTo(
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

  void _onMessageReceived(
    BuildContext context,
    String message,
  ) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
}
