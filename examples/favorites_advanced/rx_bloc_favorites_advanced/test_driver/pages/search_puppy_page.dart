import 'package:flutter_driver/flutter_driver.dart';
import 'package:favorites_advanced_base/resources.dart';

class SearchPuppyPage {
  SearchPuppyPage(FlutterDriver driver) : _driver = driver;

  final FlutterDriver _driver;

  Future<void> tapOnPuppyWithId(String id) async {
    final keyName = '${Keys.puppyCardNamePrefix}$id';
    await _driver.waitFor(
      find.byValueKey(keyName),
      timeout: const Duration(seconds: 10),
    );
    await _driver.tap(find.byValueKey(keyName));
  }
}
