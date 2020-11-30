import 'package:bloc_battle_base/core.dart';
import 'package:rx_bloc_sample/feature_home/blocs/navigation_bar_bloc.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';
import 'package:test/test.dart';

void main() {
  group('NavigationBarBloc title', () {
    rxBlocTest<NavigationBarBloc, String>(
      'NavigationBarBloc.title initial state',
      build: () async => NavigationBarBloc(),
      state: (bloc) => bloc.states.title,
      expect: <String>['Search for Puppies'],
    );

    rxBlocTest<NavigationBarBloc, String>(
      'NavigationBarBloc.title favorites',
      build: () async => NavigationBarBloc(),
      act: (bloc) async => bloc.events.selectPage(NavigationItemType.favorites),
      state: (bloc) => bloc.states.title,
      expect: <String>['Search for Puppies', 'Favorites Puppies'],
    );
  });

  group('NavigationBarBloc title', () {
    rxBlocTest<NavigationBarBloc, NavigationItem>(
      'NavigationBarBloc.title initial state',
      build: () async => NavigationBarBloc(),
      state: (bloc) => bloc.states.selectedItem,
      expect: <NavigationItem>[
        const NavigationItem(isSelected: true, type: NavigationItemType.search)
      ],
    );

    rxBlocTest<NavigationBarBloc, NavigationItem>(
      'NavigationBarBloc.title favorites',
      build: () async => NavigationBarBloc(),
      state: (bloc) => bloc.states.selectedItem,
      act: (bloc) async => bloc.events.selectPage(NavigationItemType.favorites),
      expect: <NavigationItem>[
        const NavigationItem(
          isSelected: true,
          type: NavigationItemType.search,
        ),
        const NavigationItem(
          isSelected: true,
          type: NavigationItemType.favorites,
        )
      ],
    );

    group('NavigationBarBloc title', () {
      rxBlocTest<NavigationBarBloc, List<NavigationItem>>(
        'NavigationBarBloc.items initial state',
        build: () async => NavigationBarBloc(),
        state: (bloc) => bloc.states.items,
        expect: [
          [
            const NavigationItem(
              isSelected: true,
              type: NavigationItemType.search,
            ),
            const NavigationItem(
              isSelected: false,
              type: NavigationItemType.favorites,
            ),
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
            const NavigationItem(
              isSelected: true,
              type: NavigationItemType.search,
            ),
            const NavigationItem(
              isSelected: false,
              type: NavigationItemType.favorites,
            ),
          ],
          [
            const NavigationItem(
              isSelected: false,
              type: NavigationItemType.search,
            ),
            const NavigationItem(
              isSelected: true,
              type: NavigationItemType.favorites,
            ),
          ]
        ],
      );
    });
  });
}
