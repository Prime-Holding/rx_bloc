{{> licence.dart }}

import '../data_sources/remote/count_remote_data_source.dart';
import '../models/count.dart';

/// Decouple Data Layer and Business Logic Layer
class CounterRepository {
  CounterRepository(this.countRemoteDataSource);

  final CountRemoteDataSource countRemoteDataSource;

  // Fetch current value of the counter
  Future<Count> getCurrent() => countRemoteDataSource.getCurrent();

  //Fetch incremented value of the counter
  Future<Count> increment() => countRemoteDataSource.increment();

  //Fetch decremented value of the counter
  Future<Count> decrement() => countRemoteDataSource.decrement();
}
