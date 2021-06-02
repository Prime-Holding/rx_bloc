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
  Future<Count> getCurrent();
  Future<Count> increment();
  Future<Count> decrement();
}