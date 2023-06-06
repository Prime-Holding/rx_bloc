import 'package:flutter/cupertino.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';

import '../../../base/utils/feature_otp_utils/constants.dart';
import '../../../base/utils/feature_otp_utils/enums.dart';
import '../bloc/countdown_bloc.dart';
import '../services/countdown_service.dart';
import '../widgets/countdown_component.dart';

/// Countdown dependencies that the CountdownWidget requires in order to
/// perform properly. Includes the bloc containing the states and events to
/// which the CountdownWidget can react to or manipulate.
// class CountdownDependencies {
class CountdownWidget extends StatelessWidget {
  const CountdownWidget({
    this.countdownService,
    this.countdownTime = defaultCountdownTime,
    this.controller,
    this.textStyle,
    this.onCountdownTick,
    this.timeFormat = CountdownTimeFormat.seconds,
    this.translateError,
    super.key,
  });

  /// Optional custom countdown service implementation
  final CountdownService? countdownService;

  /// The initial countdown time
  final int countdownTime;

  final CountdownController? controller;
  final TextStyle? textStyle;
  final void Function(int)? onCountdownTick;
  final CountdownTimeFormat timeFormat;
  final bool preferDoubleDigitsForTime = true;
  final String Function(Object error)? translateError;

  /// Convenience builder method that initializes CountdownComponent dependencies
  /// right above the widget.
  @override
  Widget build(BuildContext context) => MultiProvider(
        key: key,
        providers: _blocs,
        child: CountdownComponent(
          textStyle: textStyle,
          onCountdownTick: onCountdownTick,
          countdownTime: countdownTime,
          controller: controller,
          timeFormat: timeFormat,
          preferDoubleDigitsForTime: preferDoubleDigitsForTime,
          translateError: translateError,
        ),
      );

  List<RxBlocProvider> get _blocs => [
        RxBlocProvider<CountdownBlocType>(
          create: (context) => CountdownBloc(
            startTime: countdownTime,
            countdownService: countdownService,
          ),
        ),
      ];
}
