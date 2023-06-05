part of 'countdown_component.dart';

/// Countdown controller is used to gain more control over the countdown widget.
/// It allows resetting the actual timer and also has access to the remaining
/// and elapsed time from the start of the countdown.
class CountdownController extends ChangeNotifier {
  CountdownController();

  /// The internal state of the controller in which it is running
  _CountdownControllerState _state = _CountdownControllerState.normal;

  /// The max time used to be counted down from
  int _countdownTime = 0;

  /// The current remaining time
  int _remainingTime = 0;

  /// Elapsed countdown time in seconds
  int get elapsedTime => _countdownTime - _remainingTime;

  /// The remaining countdown time in seconds
  int get remainingTime => _remainingTime;

  /// Aligns the controller time with the widgets
  void _setCountdownTime(int countdownTime) {
    _countdownTime = countdownTime;
    _remainingTime = _countdownTime;
    notifyListeners();
  }

  /// Updates the time within the controller to reflect actual changes
  void _updateRemainingTime(int remainingTime) {
    _remainingTime = remainingTime;
    notifyListeners();
  }

  /// Resets the countdown timer and allows to set a new optional countdown time
  void reset({int? countdownTime}) {
    _state = _CountdownControllerState.reset;
    if (countdownTime != null) {
      _countdownTime = countdownTime;
    }
    _remainingTime = _countdownTime;
    notifyListeners();
  }
}

/// Different internal states of the countdown controller
enum _CountdownControllerState {
  /// The regular running state of the controller
  normal,

  /// Countdown controller state indicating that we need to reset the timer
  reset,
}
