import 'package:favorites_advanced_base/models.dart';
import 'package:rx_bloc_favorites_advanced/feature_home/blocs/navigation_bar_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:test/test.dart';

import '../../stubs.dart';

void main() {
  group('NavigationBarBloc title', () {
    test('dispose', () => NavigationBarBloc().dispose());

    rxBlocTest<NavigationBarBloc, String>(
      'NavigationBarBloc.title initial state',
      build: () async => NavigationBarBloc(),
      state: (bloc) => bloc.states.title,
      expect: [
        Stub.navigation.searchTitle,
      ],
    );

    rxBlocTest<NavigationBarBloc, String>(
      'NavigationBarBloc.title favorites',
      build: () async => NavigationBarBloc(),
      act: (bloc) async => bloc.events.selectPage(NavigationItemType.favorites),
      state: (bloc) => bloc.states.title,
      expect: [
        Stub.navigation.searchTitle,
        Stub.navigation.favoritesTitle,
      ],
    );
  });

  group('NavigationBarBloc title', () {
    rxBlocTest<NavigationBarBloc, NavigationItem?>(
      'NavigationBarBloc.title initial state',
      build: () async => NavigationBarBloc(),
      state: (bloc) => bloc.states.selectedItem,
      expect: [
        Stub.navigation.searchSelected,
      ],
    );

    rxBlocTest<NavigationBarBloc, NavigationItem?>(
      'NavigationBarBloc.title favorites',
      build: () async => NavigationBarBloc(),
      state: (bloc) => bloc.states.selectedItem,
      act: (bloc) async => bloc.events.selectPage(NavigationItemType.favorites),
      expect: <NavigationItem>[
        Stub.navigation.searchSelected,
        Stub.navigation.favoritesSelected,
      ],
    );

    group('NavigationBarBloc title', () {
      rxBlocTest<NavigationBarBloc, List<NavigationItem>>(
        'NavigationBarBloc.items initial state',
        build: () async => NavigationBarBloc(),
        state: (bloc) => bloc.states.items,
        expect: [
          [
            Stub.navigation.searchSelected,
            Stub.navigation.favoritesNotSelected,
          ]
        ],
      );

      rxBlocTest<NavigationBarBloc, List<NavigationItem>>(
        'NavigationBarBloc.items initial state',
        build: () async => NavigationBarBloc(),
        state: (bloc) => bloc.states.items,
        act: (bloc) async => bloc.events.selectPage(
          NavigationItemType.favorites,
        ),
        expect: [
          [
            Stub.navigation.searchSelected,
            Stub.navigation.favoritesNotSelected,
          ],
          [
            Stub.navigation.searchNotSelected,
            Stub.navigation.favoritesSelected,
          ]
        ],
      );
    });
  });
}
