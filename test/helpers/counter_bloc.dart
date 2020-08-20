import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

class CounterBloc extends RxBlocBase {
  final _loadingCount = BehaviorSubject<int>.seeded(0);

  Stream<int> get count => _loadingCount.stream;

  void increase() => ++_loadingCount.value;
  void decrease() => --_loadingCount.value;

  @override
  dispose() {
    _loadingCount.close();
    return super.dispose();
  }
}
