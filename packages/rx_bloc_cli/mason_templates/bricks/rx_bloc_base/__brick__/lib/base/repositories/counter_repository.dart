// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../../base/data_sources/domain/counter/count_data_source.dart';
import '../../base/models/count.dart';

///Can use any type of data source, that follow the contract
///and retrieve its response to the business logic layer
class CounterRepository {

  CounterRepository(this.countDataSource);

  final CountDataSource countDataSource;

  // Fetch current value of the counter
  Future<Count> getCurrent()=> countDataSource.getCurrent();

  //Fetch incremented value of the counter
  Future<Count> increment()=> countDataSource.increment();

  //Fetch decremented value of the counter
  Future<Count> decrement()=> countDataSource.decrement();

}
