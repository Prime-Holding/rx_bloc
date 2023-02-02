{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_card_component.dart';
import '../../base/common_ui_components/app_error_model_widget.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../../base/models/item_model.dart';
import '../blocs/item_details_bloc.dart';

class ItemDetailsPage extends StatelessWidget {
  const ItemDetailsPage({
    required this.itemId,
    Key? key,
  }) : super(key: key);

  final String itemId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: customAppBar(
      context,
      title: context.l10n.deepLinkFlow.itemDetailsPageTitle,
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppErrorModelWidget<ItemDetailsBlocType>(
          errorState: (bloc) => bloc.states.errors,
          isListeningForNavigationErrors: false,
        ),
        Expanded(
          child: Center(
            child: RxResultBuilder<ItemDetailsBlocType, ItemModel>(
              state: (bloc) => bloc.states.item,
              buildSuccess: (ctx, itemData, bloc) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.l10n.itemIdResult(itemData.id),
                  ),
                  Text(
                    context.l10n.itemNameResult(itemData.name),
                  ),
                  Text(
                    context.l10n
                        .itemDescriptionResult(itemData.description),
                  ),
                ],
              ),
              buildError: (context, error, bloc) => AppErrorCardComponent(
                error: error,
                onTabRetry: () => bloc.events.fetchItemDetailsById(itemId),
              ),
              buildLoading: (context, bloc) =>
              const CircularProgressIndicator(),
            ),
          ),
        )
      ],
    ),
  );
}
