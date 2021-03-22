import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

class CounterBloc extends RxBlocBase implements RxBlocTypeBase {
  final _loadingCount = BehaviorSubject<int>.seeded(0);

  Stream<int> get count => _loadingCount.stream;

  void increase() => _loadingCount.sink.add((_loadingCount.value ?? 0) + 1);
  void decrease() => _loadingCount.sink.add((_loadingCount.value ?? 0) - 1);

  @override
  void dispose() {
    _loadingCount.close();
    return super.dispose();
  }
}
