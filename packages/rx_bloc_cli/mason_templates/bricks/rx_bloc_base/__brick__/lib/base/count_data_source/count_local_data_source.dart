import 'package:project_name/base/models/count.dart';

import 'count_data_source.dart';

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

  @override
  Future<Count> getCurrent() async{
    await Future.delayed(const Duration(milliseconds: 800));
    return Count(_counter);
  }
}