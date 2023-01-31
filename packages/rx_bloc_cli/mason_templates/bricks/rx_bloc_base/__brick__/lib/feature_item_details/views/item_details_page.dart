{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../../base/common_ui_components/app_error_model_widget.dart';
import '../../base/common_ui_components/primary_button.dart';
import '../../base/extensions/error_model_translations.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/models/item_model.dart';
import '../../l10n/l10n.dart';
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
      title: Text(
        context.l10n.deepLinkFlow.itemDetailsPageTitle,
      ),
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
                  Text('Id: ${itemData.id}'),
                  Text('Name: ${itemData.name}'),
                  Text('Description: ${itemData.description}'),
                ],
              ),
              buildError: (context, error, bloc) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text((error as NetworkErrorModel).translate(context)),
                  const SizedBox(
                    height: 20,
                  ),
                  PrimaryButton(
                    onPressed: () => bloc.events.getItemDetails(itemId),
                    child: Text(context.l10n.tryAgain),
                  ),
                ],
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
