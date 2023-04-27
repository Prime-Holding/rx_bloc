import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'only_private_repository_test.mocks.dart';
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

    final service = OnlyPrivateRepository(        myName2,
        myName,
);
}