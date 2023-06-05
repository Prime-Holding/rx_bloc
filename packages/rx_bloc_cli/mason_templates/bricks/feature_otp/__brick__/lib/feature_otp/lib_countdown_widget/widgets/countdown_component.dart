import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../../base/utils/feature_otp_utils/constants.dart';
import '../../../base/utils/feature_otp_utils/enums.dart';
import '../../../base/utils/feature_otp_utils/util_methods.dart';
import '../bloc/countdown_bloc.dart';

part 'countdown_controller.dart';

/// Countdown widget used to keep track of and present the remaining time.
///
/// An [onCountdownTick] callback can be provided to keep track of any changes
/// happening. This callback accepts the remaining countdown time to which the
/// user of the widget can react. This callback is triggered after the frame
/// has been rendered in order to prevent any potential setStates happening and
/// modifying the widget during its build phase.
///
/// You can also access the remaining time, as well as the elapsed time of the
/// countdown via a [controller]. The [controller] also gives you the
/// possibility to reset the countdown and start it from a custom time (provided
/// in seconds).
///
/// By default, every countdown is presented in the format of remaining seconds.
/// However, you can change this to include minutes and hours by changing the
/// [timeFormat] parameter of the widget.
///
/// By default, the highest number (minutes in the minutes format, hours in the
/// hours format) will be displayed with double digits (even if a single digit
/// number is presented). In case you want to disable this behaviour, you can
/// set the [preferDoubleDigitsForTime] parameter to `false`.
class CountdownComponent extends StatefulWidget {
  const CountdownComponent({
    this.onCountdownTick,
    this.controller,
    this.textStyle,
    this.timeFormat = CountdownTimeFormat.seconds,
    this.countdownTime = defaultCountdownTime,
    this.preferDoubleDigitsForTime = true,
    this.translateError,
    super.key,
  });

  /// The time which will be used for the initial countdown
  final int countdownTime;

  /// Callback called every second with the remaining countdown time. This event
  /// will be called after the frame has been rendered.
  final void Function(int)? onCountdownTick;

  /// Countdown controller which allows for more control over the countdown
  final CountdownController? controller;

  /// The time format used for displaying the countdown
  final CountdownTimeFormat timeFormat;

  /// Use double digits for minutes and hours when one would be used instead
  ///
  /// example:
  /// 0:15 -> 00:15
  /// 10:30 -> 10:30
  /// 1:13:28 -> 01:13:28
  /// 52:20:09 -> 52:20:09
  final bool preferDoubleDigitsForTime;

  /// Text style of the countdown text
  final TextStyle? textStyle;

  final String Function(Object error)? translateError;

  @override
  State<CountdownComponent> createState() => _CountdownComponentState();
}

class _CountdownComponentState extends State<CountdownComponent> {
  late final CountdownController _controller;
  int remainingTime = defaultCountdownTime;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? CountdownController();
    _controller.addListener(_onControllerNotified);
    _controller._setCountdownTime(widget.countdownTime);

    // Perform an update every second
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onCountdownTick?.call(remainingTime);
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerNotified);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RxResultBuilder<CountdownBlocType, int>(
        state: (bloc) => bloc.states.remainingTime,
        buildSuccess: (context, remainingTime, bloc) {
          _controller._updateRemainingTime(remainingTime);
          this.remainingTime = remainingTime;

          return Text(
            convertRemainingTime(
              remainingTime,
              widget.timeFormat,
              widget.preferDoubleDigitsForTime,
            ),
            style: widget.textStyle,
          );
        },
        buildLoading: (context, bloc) => const CircularProgressIndicator(),
        buildError: (context, error, bloc) => ErrorCardWidget(
          text: widget.translateError?.call(error) ?? error.toString(),
          retryButtonVisible: true,
          onRetryPressed: () => bloc.events.resetTimer(),
        ),
      );

  /// Countdown controller callback happening every time the controller notifies
  /// some new changes to the external world.
  void _onControllerNotified() {
    switch (_controller._state) {
      case _CountdownControllerState.reset:
        final resetTime = _controller._countdownTime;
        context.read<CountdownBlocType>().events.resetTimer(maxTime: resetTime);
        _controller._state = _CountdownControllerState.normal;
        break;
      case _CountdownControllerState.normal:
      default:
        break;
    }
  }
}
