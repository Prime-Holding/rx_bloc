/// Service contract used to implement countdown logic
abstract class CountdownService {
  /// Method returning the stream of remaining seconds after countdown
  Stream<int> countDown({int maxTime = 60});
}
