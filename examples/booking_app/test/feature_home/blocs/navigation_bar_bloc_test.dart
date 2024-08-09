import 'package:booking_app/feature_home/blocs/navigation_bar_bloc.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NavigationBarBloc tests', () {
    late NavigationBarBloc bloc;

    setUp(() {
      bloc = NavigationBarBloc(NavigationItemType.search);
    });

    tearDown(() {
      bloc.dispose();
    });

    test('initial state is correct', () {
      final expectedItems = NavigationItemType.values
          .map((type) => NavigationItem(
                type: type,
                isSelected: type == NavigationItemType.search,
              ))
          .toList();

      expect(bloc.items, emitsInOrder([expectedItems]));
    });

    test('title stream emits correct title', () {
      const expectedTitleSearch = 'Search for Puppies';
      const expectedTitleFavorites = 'Favorites Puppies';

      bloc.events.selectPage(NavigationItemType.favorites);
      expect(
          bloc.title,
          emitsInOrder([
            expectedTitleSearch,
            expectedTitleFavorites,
          ]));
    });
  });
}
