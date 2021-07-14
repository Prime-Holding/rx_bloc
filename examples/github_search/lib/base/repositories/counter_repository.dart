// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

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
