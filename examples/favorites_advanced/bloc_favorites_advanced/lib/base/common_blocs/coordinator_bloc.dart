import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'coordinator_event.dart';
part 'coordinator_state.dart';

class CoordinatorBloc extends Bloc<CoordinatorEvent, CoordinatorState> {
  CoordinatorBloc() : super(CoordinatorInitial());

  @override
  Stream<CoordinatorState> mapEventToState(
    CoordinatorEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
