import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';

void main() {
  group('CounterBloc tests', () {
    rxBlocTest<CounterBloc, int>(
      'Basic rxBlocTest',
      build: () async => CounterBloc(),
      state: (bloc) => bloc.count,
      expect: <int>[0],
    );

    rxBlocTest<CounterBloc, int>(
      'Executing action',
      build: () async => CounterBloc(),
      state: (bloc) => bloc.count,
      act: (bloc) async => bloc.increase(),
      expect: <int>[0, 1],
    );

    rxBlocTest<CounterBloc, int>(
      'Skipping results (skips 0 and 1)',
      build: () async => CounterBloc(),
      state: (bloc) => bloc.count,
      act: (bloc) async {
        bloc..decrease()..decrease();
      },
      skip: 2,
      expect: <int>[-2],
    );
  });
}

class CounterBloc extends RxBlocBase implements RxBlocTypeBase {
  final _loadingCount = BehaviorSubject<int>.seeded(0);

  Stream<int> get count => _loadingCount.stream;

  void increase() => ++_loadingCount.value;
  void decrease() => --_loadingCount.value;

  @override
  void dispose() {
    _loadingCount.close();
    return super.dispose();
  }
}
