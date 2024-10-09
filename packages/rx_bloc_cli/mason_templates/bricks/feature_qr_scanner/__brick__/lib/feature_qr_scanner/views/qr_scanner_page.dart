{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:widget_toolkit/widget_toolkit.dart';
import 'package:widget_toolkit_qr/widget_toolkit_qr.dart';

import '../../app_extensions.dart';
import '../services/qr_service.dart';
import '../util/translate_error_util.dart';

class QrScannerPage extends StatelessWidget {
  const QrScannerPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.featureQr.qrCodePageTitle),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.widgetToolkitTheme.spacingXXXXL,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrScannerWidget<String>(
                qrValidationService: QrService(),
                onCodeValidated: (result) => showBlurredBottomSheet(
                  context: context,
                  builder: (ctx) => MessagePanelWidget(
                    message: result ?? '',
                    messageState: MessagePanelState.positiveCheck,
                  ),
                ),
                onError: (error) => showErrorBlurredBottomSheet(
                  context: context,
                  error: TranslateErrorUtil.translateError(error),
                  configuration:
                      const ModalConfiguration(showCloseButton: true),
                ),
              ),
            ],
          ),
        ),
      );
}
