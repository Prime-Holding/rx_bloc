import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'navigation_bloc.rxb.g.dart';

/// A contract class containing all events of the NavigationBloC.
abstract class NavigationBlocEvents {
  void openTab(int index);
}

/// A contract class containing all states of the NavigationBloC.
abstract class NavigationBlocStates {
  /// The error state
  Stream<String> get errors;

  /// The tap to be presented
  Stream<int> get tabIndex;
}

@RxBloc()
class NavigationBloc extends $NavigationBloc {
  @override
  Stream<int> _mapToTabIndexState() => _$openTabEvent
      .map<Result<int>>((newIndex) {
        /// TODO: Add a real navigation permission check
        final now = DateTime.now();
        if (now.minute % 4 == 0) {
          return Result.error(
              Exception('It isn\'t the right time for changes!'));
        }
        return Result.success(newIndex);
      })
      .setResultStateHandler(this)
      .whereSuccess();

  @override
  Stream<String> _mapToErrorsState() => errorState
      .map((error) => error.toString().replaceFirst('Exception: ', ''));
}
