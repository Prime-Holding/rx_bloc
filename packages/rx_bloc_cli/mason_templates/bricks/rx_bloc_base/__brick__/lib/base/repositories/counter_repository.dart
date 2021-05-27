// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../../base/count_data_source/count_data_source.dart';
import '../../base/models/count.dart';

class CounterRepository {

  CounterRepository(this.countDataSource);

  final CountDataSource countDataSource;

  Future<Count> getCurrent()=> countDataSource.getCurrent();
  Future<Count> increment()=> countDataSource.increment();
  Future<Count> decrement()=> countDataSource.decrement();

}
