import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

class CommonFunctionalities {
  //Checks is an element is present
  static Future<bool> isPresent(
      SerializableFinder finder, FlutterDriver driver, Duration timeOut) async {
    try {
      await driver.waitFor(finder, timeout: timeOut);
      return true;
    } catch (e) {
      return false;
    }
  }

  //Performs multiple clicks
  static Future<void> multipleTaps(
      SerializableFinder finder, FlutterDriver driver, int increments) async {
    for (var i = 0; i <= increments; i++) {
      await driver.tap(finder);
    }
  }
  
  static Future<void> waitForTextToChange(SerializableFinder finder, FlutterDriver driver) async{
    var result = false;

    await driver.waitFor(finder);
    var initialText = await driver.getText(finder);

    while(!result){
      try{
        expect(await driver.getText(finder), isNot(initialText));
        result = true;
      }
      catch(e){
        result = false;
      }
    }
  }
}
