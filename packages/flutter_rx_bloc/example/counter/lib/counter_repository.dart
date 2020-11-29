/// This will simulate a server with 100 milliseconds response time
class CounterRepository {
  int _counter = 0;

  Future<int> increment() async {
    // Server response time.
    await Future.delayed(Duration(milliseconds: 800));
    // Simulate an error from the server when the counter reached 2.
    if (_counter == 2) {
      throw Exception('Maximum number is reached!');
    }

    return ++_counter;
  }

  Future<int> decrement() async {
    // Server response time.
    await Future.delayed(Duration(milliseconds: 800));
    // Simulate an error from the server when the counter reached 2.
    if (_counter <= 0) {
      throw Exception('Minimum number is reached!');
    }

    return --_counter;
  }
}
