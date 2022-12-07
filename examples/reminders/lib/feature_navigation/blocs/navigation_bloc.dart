import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'navigation_bloc.rxb.g.dart';

enum NavigationTabs {
  dashboard,
  reminders,
}

/// A contract class containing all events of the NavigationBloC.
abstract class NavigationBlocEvents {
  void openTab(NavigationTabs tab);
}

/// A contract class containing all states of the NavigationBloC.
abstract class NavigationBlocStates {
  /// The error state
  Stream<String> get errors;

  /// The tap to be presented
  Stream<NavigationTabs> get tab;
}

@RxBloc()
class NavigationBloc extends $NavigationBloc {
  @override
  Stream<NavigationTabs> _mapToTabState() => _$openTabEvent
      .map<Result<NavigationTabs>>((tab) {
        /// TODO: Add a real navigation permission check
        return Result.success(tab);
      })
      .setResultStateHandler(this)
      .whereSuccess();

  @override
  Stream<String> _mapToErrorsState() => errorState
      .map((error) => error.toString().replaceFirst('Exception: ', ''));
}
