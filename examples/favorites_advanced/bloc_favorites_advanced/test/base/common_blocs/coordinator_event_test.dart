import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../stubs.dart';

void main() {
  group('CoordinatorEvent', () {
    group('CoordinatorPuppyUpdatedEvent', () {
      test('Test value comparisons', () {
        expect(CoordinatorPuppyUpdatedEvent(Stub.puppy1),
            CoordinatorPuppyUpdatedEvent(Stub.puppy1));
      });
    });


    group('CoordinatorPuppiesUpdatedEvent', () {
      test('Test value comparisons', () {
        expect(CoordinatorPuppiesUpdatedEvent(Stub.favoritePuppies123),
            CoordinatorPuppiesUpdatedEvent(Stub.favoritePuppies123));
      });
    });
  });
}
