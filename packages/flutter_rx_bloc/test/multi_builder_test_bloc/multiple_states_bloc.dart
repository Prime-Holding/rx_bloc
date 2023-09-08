import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'multiple_states_bloc.rxb.g.dart';

abstract class MultipleStatesBlocEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void addState1(String value);

  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void addState2(String value);

  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void addState3(String value);
}

abstract class MultipleStatesBlocStates {
  Stream<String> get state1;

  Stream<String> get state2;

  Stream<String> get state3;
}

@RxBloc()
class MultipleStatesBloc extends $MultipleStatesBloc {
  MultipleStatesBloc([String? initial1, String? initial2, String? initial3]) {
    if (initial1 != null) {
      _$addState1Event.add(initial1);
    }
    if (initial2 != null) {
      _$addState2Event.add(initial2);
    }
    if (initial3 != null) {
      _$addState3Event.add(initial3);
    }
  }

  @override
  Stream<String> _mapToState1State() => _$addState1Event;

  @override
  Stream<String> _mapToState2State() => _$addState2Event;

  @override
  Stream<String> _mapToState3State() => _$addState3Event;
}
