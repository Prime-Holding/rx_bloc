{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/common_ui_components/app_error_widget.dart';
import '../../base/common_ui_components/app_loading_indicator.dart';
import '../../base/models/deep_link_model.dart';
import '../blocs/deep_link_details_bloc.dart';

class DeepLinkDetailsPage extends StatelessWidget {
  const DeepLinkDetailsPage({
    required this.deepLinkId,
    Key? key,
  }) : super(key: key);

  final String deepLinkId;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: _appBarTitle(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppErrorModalWidget<DeepLinkDetailsBlocType>(
              errorState: (bloc) => bloc.states.errors,
              isListeningForNavigationErrors: false,
            ),
            Expanded(
              child: Center(
                child: RxResultBuilder<DeepLinkDetailsBlocType, DeepLinkModel>(
                  state: (bloc) => bloc.states.deepLink,
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
                    onTabRetry: () =>
                        bloc.events.fetchDeepLinkDetailsById(deepLinkId),
                  ),
                  buildLoading: (context, bloc) =>
                      AppLoadingIndicator.taskValue(context),
                ),
              ),
            )
          ],
        ),
      );

  Widget _appBarTitle() =>
      RxResultBuilder<DeepLinkDetailsBlocType, DeepLinkModel>(
        state: (bloc) => bloc.states.deepLink,
        buildSuccess: (ctx, itemData, bloc) => Text(itemData.name),
        buildError: (context, error, bloc) => Text(context.l10n.errorState),
        buildLoading: (context, bloc) => Text(context.l10n.loadingState),
      );
}
