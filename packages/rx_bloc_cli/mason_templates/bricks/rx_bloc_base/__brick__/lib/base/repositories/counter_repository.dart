// Copyright (c) 2021, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

/// This will simulate a server with 100 milliseconds response time
class CounterRepository {
  int _counter = 0;

  /// Increment the stored counter by one
  Future<int> increment() async {
    // Server response time.
    await Future.delayed(const Duration(milliseconds: 800));
    // Simulate an error from the server when the counter reached 2.
    if (_counter == 2) {
      throw Exception('Maximum number is reached!');
    }

    return ++_counter;
  }

  /// Decrement the stored counter by one
  Future<int> decrement() async {
    // Server response time.
    await Future.delayed(const Duration(milliseconds: 800));
    // Simulate an error from the server when the counter reached 2.
    if (_counter <= 0) {
      throw Exception('Minimum number is reached!');
    }

    return --_counter;
  }
}
