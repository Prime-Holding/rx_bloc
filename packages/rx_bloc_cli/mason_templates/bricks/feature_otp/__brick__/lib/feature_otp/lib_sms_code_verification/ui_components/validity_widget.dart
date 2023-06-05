import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/theme_data.dart';

import '../../../base/utils/feature_otp_utils/enums.dart';
import '../../../base/utils/feature_otp_utils/util_methods.dart';
import '../../../l10n/l10n.dart';
import '../bloc/sms_code_bloc.dart';

/// ValidityWidget presents how long a code is valid. It depends on SmsCodeBlocType,
/// so make sure you have that bloc provided in the context above this widget.
/// It can be customised a bit or implemented on your own way using [builder] method.
class ValidityWidget extends StatelessWidget {
  const ValidityWidget(
      {this.title,
      this.builder,
      this.placeholder,
      this.timeFormat = CountdownTimeFormat.minutes,
      this.textStyle,
      Key? key})
      : super(key: key);

  /// Text to be displayed on top of the counter
  final String? title;

  /// Use [builder] method to overwrite the widget appearance
  final Widget Function(int remainingTime)? builder;

  /// Widget to be displayed if there is no data from the bloc
  final Widget? placeholder;

  /// Define how to style the counter numbers
  final TextStyle? textStyle;

  /// How to format the time. Choose from predefined values
  final CountdownTimeFormat? timeFormat;

  @override
  Widget build(BuildContext context) => RxBlocBuilder<SmsCodeBlocType, int>(
        bloc: context.read<SmsCodeBlocType>(),
        state: (bloc) => bloc.states.validityTime,
        builder: (context, validityTime, bloc) => (validityTime.hasData)
            ? builder?.call(validityTime.data!) ??
                _buildValidityWidget(
                  context,
                  validityTime.data ?? 0,
                )
            : placeholder ?? const SizedBox(),
      );

  Widget _buildValidityWidget(BuildContext context, int time) => Column(
        children: [
          Text(
            title ?? context.l10n.featureOtp.codeValidity,
            style: context.widgetToolkitTheme.titleBold,
          ),
          Text(
            '${convertRemainingTime(time, timeFormat ?? CountdownTimeFormat.minutes, true)} ${context.l10n.featureOtp.minutes}',
            style: textStyle,
          ),
        ],
      );
}
