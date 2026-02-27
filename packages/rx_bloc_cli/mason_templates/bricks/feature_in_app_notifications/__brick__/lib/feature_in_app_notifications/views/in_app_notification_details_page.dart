import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_widget.dart';
import '../../base/common_ui_components/app_image.dart';
import '../../base/common_ui_components/app_loading_indicator.dart';
import '../../base/common_ui_components/custom_app_bar.dart';
import '../blocs/in_app_notification_details_bloc.dart';
import '../models/in_app_notification_model.dart';

class InAppNotificationDetailsPage extends StatefulWidget {
  const InAppNotificationDetailsPage({
    required this.notificationId,
    super.key,
  });

  final String notificationId;

  @override
  State<InAppNotificationDetailsPage> createState() =>
      _InAppNotificationDetailsPageState();
}

class _InAppNotificationDetailsPageState
    extends State<InAppNotificationDetailsPage> {
  QuillController? _quillController;

  @override
  void dispose() {
    _quillController?.dispose();
    super.dispose();
  }

  QuillController _buildController(List<dynamic> deltaJson) {
    if (_quillController != null) return _quillController!;
    final document = Document.fromJson(deltaJson);
    _quillController = QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true,
    );
    return _quillController!;
  }

  @override
  Widget build(BuildContext context) =>
      RxResultBuilder<InAppNotificationDetailsBlocType,
          InAppNotificationModel>(
        state: (bloc) => bloc.states.notification,
        buildLoading: (context, bloc) => Scaffold(
          appBar: customAppBar(context),
          body: Center(child: AppLoadingIndicator.taskValue(context)),
        ),
        buildError: (context, error, bloc) => Scaffold(
          appBar: customAppBar(context),
          body: Center(
            child: AppErrorWidget(
              error: error,
              onTabRetry: () =>
                  bloc.events.fetchNotification(widget.notificationId),
            ),
          ),
        ),
        buildSuccess: (context, notification, bloc) {
          final body = notification.body;

          Widget content;
          if (body == null || body.isEmpty) {
            content = Center(
              child: Text(
                notification.description,
                style: context.designSystem.typography.h2Reg16,
              ),
            );
          } else {
            final controller = _buildController(body);
            content = Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.designSystem.spacing.l,
                vertical: context.designSystem.spacing.m,
              ),
              child: QuillEditor.basic(
                controller: controller,
                config: QuillEditorConfig(
                  showCursor: false,
                  embedBuilders: [
                    _ImageEmbedBuilder(),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            appBar: customAppBar(context),
            body: content,
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.designSystem.spacing.xxxxl,
                  vertical: context.designSystem.spacing.m,
                ),
                child: GradientFillButton(
                  text: context.l10n.inAppNotificationDetailsCta,
                  state: ButtonStateModel.enabled,
                  onPressed: () {
                    // TODO: Do something on button press
                  },
                ),
              ),
            ),
          );
        },
      );
      
}

class _ImageEmbedBuilder extends EmbedBuilder {
  @override
  String get key => BlockEmbed.imageType;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) => Padding(
      padding: EdgeInsets.symmetric(vertical: context.designSystem.spacing.xs),
      child: AppImage(
        embedContext.node.value.data as String,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) => SizedBox(
          child: Center(
            child: Icon(
              Icons.broken_image,
              size: context.designSystem.spacing.xxxxl,
            ),
          ),
        ),
      ),
    );
}