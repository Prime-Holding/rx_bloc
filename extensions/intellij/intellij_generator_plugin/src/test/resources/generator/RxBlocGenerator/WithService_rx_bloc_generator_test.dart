import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../services/profile_dart_service.dart';

part 'profile_dart_bloc.rxb.g.dart';

/// A contract class containing all events of the ProfileDartBloC
abstract class ProfileDartBlocEvents {
  /// TODO: Document the event
  void fetchData();
}

/// A contract class containing all states of the ProfileDartBloC.
abstract class ProfileDartBlocStates {
  /// TODO: Document the state
  Stream<Result<String>> get data;
}

@RxBloc()
class ProfileDartBloc extends $ProfileDartBloc {
  ProfileDartBloc(this.profileDartService);

  final ProfileDartService profileDartService;

  @override
  Stream<Result<String>> _mapToDataState() => _$fetchDataEvent
      .startWith(null)
      .switchMap((value) => profileDartService.fetchData().asResultStream())
      .setResultStateHandler(this)
      .shareReplay(maxSize: 1);
}