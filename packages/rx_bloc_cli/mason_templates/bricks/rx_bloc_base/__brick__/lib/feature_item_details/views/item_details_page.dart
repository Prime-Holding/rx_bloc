{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/common_ui_components/app_error_widget.dart';
import '../../base/common_ui_components/app_loading_indicator.dart';
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
        appBar: AppBar(
          title: _appBarTitle(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppErrorModalWidget<ItemDetailsBlocType>(
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
                        itemData.description,
                        style: context.designSystem.typography.h1Reg20,
                      ),
                    ],
                  ),
                  buildError: (context, error, bloc) => AppErrorWidget(
                    error: error,
                    onTabRetry: () => bloc.events.fetchItemDetailsById(itemId),
                  ),
                  buildLoading: (context, bloc) =>
                      AppLoadingIndicator.taskValue(context),
                ),
              ),
            )
          ],
        ),
      );

  Widget _appBarTitle() => RxResultBuilder<ItemDetailsBlocType, ItemModel>(
        state: (bloc) => bloc.states.item,
        buildSuccess: (ctx, itemData, bloc) => Text(itemData.name),
        buildError: (context, error, bloc) => Text(context.l10n.errorState),
        buildLoading: (context, bloc) => Text(context.l10n.loadingState),
      );
}
