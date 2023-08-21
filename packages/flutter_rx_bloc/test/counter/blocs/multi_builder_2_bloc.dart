import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'multi_builder_2_bloc.rxb.g.dart';

abstract class MultiBuilder2BlocEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void addState1(String value);

  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void addState2(String value);
}

abstract class MultiBuilder2BlocStates {
  Stream<String> get state1;

  Stream<String> get state2;
}

@RxBloc()
class MultiBuilder2Bloc extends $MultiBuilder2Bloc {
  MultiBuilder2Bloc([String? initial1, String? initial2]) {
    if (initial1 != null) {
      _$addState1Event.add(initial1);
    }
    if (initial2 != null) {
      _$addState2Event.add(initial2);
    }
  }

  @override
  Stream<String> _mapToState1State() => _$addState1Event;

  @override
  Stream<String> _mapToState2State() => _$addState2Event;
}
