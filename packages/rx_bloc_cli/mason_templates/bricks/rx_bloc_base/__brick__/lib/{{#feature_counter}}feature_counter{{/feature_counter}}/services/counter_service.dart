{{> licence.dart }}

import '../../base/models/count.dart';
import '../../base/repositories/counter_repository.dart';

class CounterService {
  CounterService(this._repository);

  final CounterRepository _repository;

  Future<Count> getCurrent() => _repository.getCurrent();

  Future<Count> increment() => _repository.increment();

  Future<Count> decrement() => _repository.decrement();
}
