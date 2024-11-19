import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../services/rose_service.dart';

part 'rose_bloc.rxb.g.dart';

/// A contract class containing all events of the RoseBloC.
abstract class RoseBlocEvents {
  /// TODO: Document the event
  void fetchData();
}

/// A contract class containing all states of the RoseBloC.
abstract class RoseBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<String> get errors;

  @RxBlocIgnoreState()
  Stream<Result<String>> get data;
}

@RxBloc()
class RoseBloc extends $RoseBloc {
  RoseBloc(this.roseService);

  final RoseService roseService;

  @override
  Stream<Result<String>> _mapToDataState() => _$fetchDataEvent
      .startWith(null)
      .switchMap((value) => roseService.fetchData().asResultStream())
      .setResultStateHandler(this)
      .shareReplay(maxSize: 1);

  /// TODO: Implement error event-to-state logic
  @override
  Stream<String> _mapToErrorsState() => errorState.map((error) {
        String msg = error.toString();
        if (msg.contains('Exception:')) msg = msg.replaceAll('Exception:', '');
        return msg.trim();
      });

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  // TODO: implement data
  Stream<Result<String>> get data => throw UnimplementedError();
}
