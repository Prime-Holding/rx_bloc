// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../../base/models/count.dart';

import 'count_data_source.dart';

///This class simulate local data source.
///It holds the state of the app and all calculating logic.
class CountLocalDataSource implements CountDataSource{

  int _counter = 0;

  /// Increment the stored counter by one
  @override
  Future<Count> increment() async {
    // Server response time.
    await Future.delayed(const Duration(milliseconds: 800));
    // Simulate an error from the server when the counter reached 2.
    if (_counter == 2) {
      throw Exception('Maximum number is reached!');
    }

    return Count(++_counter);
  }

  /// Decrement the stored counter by one
  @override
  Future<Count> decrement() async {
    // Server response time.
    await Future.delayed(const Duration(milliseconds: 800));
    // Simulate an error from the server when the counter reached 2.
    if (_counter <= 0) {
      throw Exception('Minimum number is reached!');
    }

    return Count(--_counter);
  }

  /// Get current value
  @override
  Future<Count> getCurrent() async{
    await Future.delayed(const Duration(milliseconds: 800));
    return Count(_counter);
  }
}