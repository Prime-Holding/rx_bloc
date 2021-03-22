import 'package:bloc_sample/feature_home/blocs/navigation_bar_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:test/test.dart';

import '../../stubs.dart';

void main() {
  // group('NavigationBarBloc', () {
  //   blocTest<NavigationBarBloc, NavigationBarState>(
  //     'NavigationBarBloc.NavigationBarState initial',
  //     build: () => NavigationBarBloc(),
  //     expect: const <NavigationBarState>[],
  //   );
  //
  //   blocTest<NavigationBarBloc, NavigationBarState>(
  //     'NavigationBarBloc.NavigationBarState favorites',
  //     build: () => NavigationBarBloc(),
  //     act: (bloc) =>
  //         bloc.add(const NavigationBarEvent(NavigationItemType.favorites)),
  //     expect: <NavigationBarState>[
  //       Stub.navigation.favoritesState,
  //     ],
  //   );
  //
  //   blocTest<NavigationBarBloc, NavigationBarState>(
  //     'NavigationBarBloc.NavigationBarState search',
  //     build: () => NavigationBarBloc(),
  //     act: (bloc) =>
  //         bloc.add(const NavigationBarEvent(NavigationItemType.search)),
  //     expect: <NavigationBarState>[
  //       Stub.navigation.initialSearchState,
  //     ],
  //   );
  //
  //   blocTest<NavigationBarBloc, NavigationBarState>(
  //     'NavigationBarBloc.NavigationBarState search favorites',
  //     build: () => NavigationBarBloc(),
  //     act: (bloc) => bloc
  //       ..add(const NavigationBarEvent(NavigationItemType.search))
  //       ..add(const NavigationBarEvent(NavigationItemType.favorites)),
  //     expect: <NavigationBarState>[
  //       Stub.navigation.initialSearchState,
  //       Stub.navigation.favoritesState,
  //     ],
  //   );
  //
  //   blocTest<NavigationBarBloc, NavigationBarState>(
  //     'NavigationBarBloc.NavigationBarState search search',
  //     build: () => NavigationBarBloc(),
  //     act: (bloc) => bloc
  //       ..add(const NavigationBarEvent(NavigationItemType.search))
  //       ..add(const NavigationBarEvent(NavigationItemType.search)),
  //     expect: <NavigationBarState>[
  //       Stub.navigation.initialSearchState,
  //     ],
  //   );
  // });
}
