import 'dart:math';

class DetailsRepository {
  var randomizer = new Random();
  
  Future<String> fetch() =>
      Future.delayed(Duration(seconds: 1), () => "Details has been loaded - ${randomizer.nextInt(100)}");
}
