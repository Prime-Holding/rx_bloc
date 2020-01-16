import 'dart:math';

class DetailsRepository {
  var _randomizer = new Random();
  
  Future<String> fetch() =>
      Future.delayed(Duration(seconds: 1), () => "Details have been loaded - ${_randomizer.nextInt(100)}");
}
