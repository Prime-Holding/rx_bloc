import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widget_toolkit/shimmer.dart';
import 'package:widget_toolkit/text_field_dialog.dart';

import '../../app_extensions.dart';

class PushTokenWidget extends StatelessWidget {
  const PushTokenWidget(
      {required this.label, this.value, this.error, super.key});

  final String label;
  final String? value;
  final String? error;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () {
          if (value != null) {
            Clipboard.setData(ClipboardData(text: value!));
          }
        },
        customBorder: const CircleBorder(),
        child: Container(
          decoration: BoxDecoration(
            color: context.textFieldDialogTheme.editFieldRegularBackground,
            borderRadius: BorderRadius.circular(
              context.textFieldDialogTheme.editFieldBorderRadius,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: context.textFieldDialogTheme.spacingS,
              horizontal: context.textFieldDialogTheme.spacingM,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: context.textFieldDialogTheme.captionBold
                            .copyWith(
                                color: context.textFieldDialogTheme
                                    .editFieldLabelNotEditedColor),
                      ),
                      SizedBox(height: context.textFieldDialogTheme.spacingXSS),
                      ShimmerText(
                        error ?? value,
                        style: context.textFieldDialogTheme
                            .editFieldTextNotEditedTextStyle
                            .copyWith(
                                color: error == null
                                    ? context.textFieldDialogTheme
                                        .editFieldValueNotEditedColor
                                    : context.designSystem.colors.errorColor),
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: value != null,
                  replacement: SizedBox(),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: context.textFieldDialogTheme.spacingS,
                        top: context.textFieldDialogTheme.spacingXS,
                        bottom: context.textFieldDialogTheme.spacingXS),
                    child: Material(
                      color: Colors.transparent,
                      child: Icon(context.designSystem.icons.copy),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
