import 'package:bloc_sample/feature_puppy/search/blocs/puppy_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../stubs.dart';

void main() {
  group('PuppyListEvent', () {
    group('ReloadPuppiesEvent', () {
      test('support value comparisons', () {
        expect(ReloadPuppiesEvent(), ReloadPuppiesEvent());
      });
    });

    group('LoadPuppyListEvent', () {
      test('support value comparisons', () {
        expect(LoadPuppyListEvent(), LoadPuppyListEvent());
      });
    });

    group('FavoritePuppiesUpdatedEvent', () {
      test('support value comparisons', () {
        expect(
          PuppyListFavoritePuppiesUpdatedEvent(
            favoritePuppies: Stub.favoritePuppies,
          ),
          PuppyListFavoritePuppiesUpdatedEvent(
            favoritePuppies: Stub.favoritePuppies,
          ),
        );
      });
    });
  });
}
