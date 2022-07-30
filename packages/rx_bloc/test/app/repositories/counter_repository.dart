/// This will simulate a server with 100 milliseconds response time.
class CounterRepository {
  int _counter = 0;

  static const delay = Duration(milliseconds: 100);
  static const delayTest = Duration(milliseconds: 120);

  Future<int> increment() async {
    // Server response time.
    await Future.delayed(delay);

    if (_counter >= 3) {
      throw Exception('Maximum number is reached!');
    }

    return ++_counter;
  }

  Future<int> decrement() async {
    // Server response time.
    await Future.delayed(delay);
    // Simulate an error from the server when the counter goes less than 1.
    if (_counter <= 0) {
      throw Exception('Minimum number is reached!');
    }

    return --_counter;
  }
}
