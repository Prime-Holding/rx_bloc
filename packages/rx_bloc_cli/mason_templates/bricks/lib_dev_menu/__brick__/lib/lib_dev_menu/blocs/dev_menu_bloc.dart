import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'dev_menu_bloc.rxb.g.dart';

/// A contract class containing all events of the DevMenuBloC.
abstract class DevMenuBlocEvents {
  void tap();
}

/// A contract class containing all states of the DevMenuBloC.
abstract class DevMenuBlocStates {
  Stream<void> get onDevMenuPresented;
}

@RxBloc()
class DevMenuBloc extends $DevMenuBloc {
  int _tapCount = 0;
  static const thresholdTaps = 5;

  @override
  Stream<void> _mapToOnDevMenuPresentedState() => _$tapEvent
      .doOnData((_) => _tapCount += 1)
      .map((event) => _tapCount)
      .debounceTime(const Duration(milliseconds: 300))
      .where(_hasPassedThreshold);

  bool _hasPassedThreshold(int count) {
    _tapCount = 0;
    return count >= thresholdTaps;
  }
}
