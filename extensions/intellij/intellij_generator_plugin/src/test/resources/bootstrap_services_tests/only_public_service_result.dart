import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'only_public_service_test.mocks.dart';
@GenerateMocks([
  MyType2,
  MyType1,
])
void main() {
  late MyType2 myName2;
  late MyType1 myName;

  setUp(() {
    myName2 = MockMyType2();
    myName = MockMyType1();
  });

    final service = OnlyPublicService(        myName2: myName2,
        myName: myName,
);
 group('OnlyPublicService callMeSafely tests', () {

    test('test OnlyPublicService callMeSafely case 1', () async {
    });
 });
 group('OnlyPublicService callMeSafely2 tests', () {

    test('test OnlyPublicService callMeSafely2 case 1', () async {
    });
 });
}