// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../../../../base/models/count.dart';

/// A contract class containing all methods,
/// that  should be implemented by real data source
abstract class CountDataSource{

  // Take current value of the counter
  Future<Count> getCurrent();

  //Increment the value of the counter with one and return it
  Future<Count> increment();

  //Decrement the value of the counter with one and return it
  Future<Count> decrement();
}