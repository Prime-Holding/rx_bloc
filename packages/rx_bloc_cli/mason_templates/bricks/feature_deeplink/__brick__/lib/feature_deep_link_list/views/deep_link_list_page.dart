{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/widget_toolkit.dart' hide ErrorModel;

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/common_ui_components/app_error_widget.dart';
import '../../base/common_ui_components/app_loading_indicator.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../../base/models/deep_link_model.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../blocs/deep_link_list_bloc.dart';
import '../ui_components/enter_message_button.dart';

class DeepLinkListPage extends StatelessWidget {
  const DeepLinkListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: customAppBar(
          context,
          title: context.l10n.featureDeepLink.deepLinkFlowPageTitle,
          actions: [
            RxLoadingBuilder<DeepLinkListBlocType>(
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
            AppErrorModalWidget<DeepLinkListBlocType>(
              errorState: (bloc) => bloc.states.errors,
            ),
            RxBlocListener<DeepLinkListBlocType, String>(
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
                child:
                    RxResultBuilder<DeepLinkListBlocType, List<DeepLinkModel>>(
                  state: (bloc) => bloc.states.deepLinkList,
                  buildError: (ctx, error, bloc) => AppErrorWidget(
                    error: error,
                    onTabRetry: () => bloc.events.fetchDeepLinkList(),
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
                        OutlineFillButton(
                      text: items[index].name,
                      onPressed: () =>
                          context.read<RouterBlocType>().events.push(
                                DeepLinkDetailsRoute(items[index].id),
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
      showBlurredBottomSheet(
        context: rootNavigatorKey.currentContext ?? context,
        builder: (BuildContext context) => Padding(
          padding: EdgeInsets.fromLTRB(
            context.designSystem.spacing.l,
            context.designSystem.spacing.l,
            context.designSystem.spacing.l,
            0,
          ),
          child: MessagePanelWidget(
            message: message,
            messageState: MessagePanelState.informative,
          ),
        ),
        configuration: const ModalConfiguration(
          safeAreaBottom: false,
        ),
      );
}
