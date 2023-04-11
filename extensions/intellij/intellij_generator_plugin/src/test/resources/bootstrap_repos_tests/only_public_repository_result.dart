import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'only_public_repository_test.mocks.dart';
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

    final service = OnlyPublicRepository(        myName2: myName2,
        myName: myName,
);
 group('OnlyPublicRepository callMeSafely tests', () {

    test('test OnlyPublicRepository callMeSafely case 1', () async {
    });
 });
 group('OnlyPublicRepository callMeSafely2 tests', () {

    test('test OnlyPublicRepository callMeSafely2 case 1', () async {
    });
 });
}