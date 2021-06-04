import 'package:rxdart/rxdart.dart';
import 'package:{{project_name}}/feature_counter/blocs/counter_bloc.dart';

class CounterBlocEventsMock extends CounterBlocEvents {
  @override
  void decrement() {}

  @override
  void increment() {}
}

class CounterBlocStatesMock extends CounterBlocStates {
  final countSubject = BehaviorSubject<int>();

  @override
  Stream<int> get count => countSubject;

  final errorsSubject = BehaviorSubject<String>();

  @override
  Stream<String> get errors => errorsSubject;

  final isLoadingSubject = BehaviorSubject<bool>();

  @override
  Stream<bool> get isLoading => isLoadingSubject;

  void dispose() {
    countSubject.close();
    errorsSubject.close();
    isLoadingSubject.close();
  }
}

class CounterBlocMock extends CounterBlocType {
  final eventsMock = CounterBlocEventsMock();

  @override
  CounterBlocEvents get events => eventsMock;

  final statesMock = CounterBlocStatesMock();

  @override
  CounterBlocStates get states => statesMock;

  void setStates({String? error, int? count, bool? isLoading}) {
    if (error != null) {
      statesMock.errorsSubject.value = error;
    }

    if (count != null) {
      statesMock.countSubject.value = count;
    }

    if (isLoading != null) {
      statesMock.isLoadingSubject.value = isLoading;
    }
  }

  @override
  void dispose() {
    statesMock.dispose();
  }
}
