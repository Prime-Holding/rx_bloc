import 'package:booking_app/feature_home/blocs/navigation_bar_bloc.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:rx_bloc_test/rx_bloc_test.dart';

import '../../stubs.dart';
import '../mock/navigation_bar_mock.dart';

@GenerateMocks([])
void main() {
  group('Navigation Bar Bloc tests', () {
    rxBlocTest<NavigationBarBlocType, List<NavigationItem>>(
      'Navigation Bar Bloc initial state',
      build: () async =>
          navigationBarMock(navigationType: NavigationItemType.search),
      state: (bloc) => bloc.states.items,
      expect: [Stub.navBarItemsList],
    );

    rxBlocTest<NavigationBarBlocType, NavigationItem>(
      'Navigation Bar Bloc selected item',
      build: () async =>
          navigationBarMock(navigationType: NavigationItemType.search),
      state: (bloc) => bloc.states.selectedItem,
      expect: [Stub.navBarSelectedItem],
    );
  });
}
