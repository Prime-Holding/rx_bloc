import 'package:bloc_sample/feature_puppy/search/blocs/puppy_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../stubs.dart';

void main() {
  group('PuppyListState', () {
    test('value comparison', () {
      expect(
        const PuppyListState(searchedPuppies: []),
        const PuppyListState(searchedPuppies: []),
      );
    });

    test('returns same object when no properties are passed', () {
      expect(const PuppyListState(searchedPuppies: []).copyWith(),
          const PuppyListState(searchedPuppies: []));
    });

    test(
        'return object with updates searchedPuppies '
        'when searchedPuppies is passed', () {
      expect(
          const PuppyListState(searchedPuppies: [])
              .copyWith(searchedPuppies: Stub.favoritePuppies),
          PuppyListState(searchedPuppies: Stub.favoritePuppies));
    });

    test(
        'return object with updates status '
        'when status is passed', () {
      expect(
          const PuppyListState(searchedPuppies: [])
              .copyWith(status: PuppyListStatus.success),
          const PuppyListState(
              searchedPuppies: [], status: PuppyListStatus.success));
    });
  });
}
