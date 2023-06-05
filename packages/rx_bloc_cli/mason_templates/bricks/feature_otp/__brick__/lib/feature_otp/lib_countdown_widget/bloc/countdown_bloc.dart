import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../base/utils/feature_otp_utils/constants.dart';
import '../services/countdown_service.dart';
import '../services/countdown_service_impl.dart';

part 'countdown_bloc.rxb.g.dart';

/// A contract class containing all events of the CountdownBloc.
abstract class CountdownBlocEvents {
  /// Resets the timer
  void resetTimer({int maxTime = defaultCountdownTime});
}

/// A contract class containing all states of the CountdownBloc.
abstract class CountdownBlocStates {
  /// Remaining countdown time in seconds
  Stream<Result<int>> get remainingTime;
}

/// A Countdown [RxBloc](https://pub.dev/packages/rx_bloc) which contains logic
/// required to make the CountdownWidget work. Defines contracts which allow for
/// effortless countdown functionality to be used within minutes.
///
/// An implementation of the [CountdownService] can be provided which will be
/// used instead of handling the countdown logic.
@RxBloc()
class CountdownBloc extends $CountdownBloc {
  CountdownBloc({
    int startTime = defaultCountdownTime,
    CountdownService? countdownService,
  })  : _countdownService = countdownService ?? CountdownServiceImpl(),
        _initialTime = startTime;

  /// The countdown service used to perform the actual countdown logic
  final CountdownService _countdownService;

  /// The initial time used to start the countdown
  final int _initialTime;

  @override
  Stream<Result<int>> _mapToRemainingTimeState() =>
      _$resetTimerEvent.startWith(_initialTime).switchMap((time) =>
          _countdownService.countDown(maxTime: time).asResultStream());
}
