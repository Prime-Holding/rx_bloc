import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../stubs.dart';

void main() {
  late CoordinatorBloc coordinatorBloc;

  setUp(() {
    coordinatorBloc = CoordinatorBloc();
  });

  blocTest<CoordinatorBloc, CoordinatorState>(
    'CoordinatorBloc CoordinatorFavoritePuppyUpdatedEvent',
    build: () => coordinatorBloc,
    act: (bloc) {
      bloc.add(CoordinatorFavoritePuppyUpdatedEvent(
        favoritePuppy: Stub.isNotFavoritePuppy3,
        updateException: '',
      ));
    },
    expect: () => <CoordinatorState>[
      CoordinatorFavoritePuppyUpdatedState(
        favoritePuppy: Stub.isNotFavoritePuppy3,
        updateException: '',
      ),
    ],
  );

  blocTest<CoordinatorBloc, CoordinatorState>(
    'CoordinatorBloc CoordinatorPuppiesUpdatedEvent',
    build: () => coordinatorBloc,
    act: (bloc) {
      bloc.add(CoordinatorPuppiesUpdatedEvent(Stub.favoritePuppies123));
    },
    expect: () => <CoordinatorState>[
      CoordinatorPuppiesUpdatedState(Stub.favoritePuppies123)
    ],
  );

  blocTest<CoordinatorBloc, CoordinatorState>(
    'CoordinatorBloc CoordinatorPuppiesUpdatedEvent',
    build: () => coordinatorBloc,
    act: (bloc) {
      bloc.add(CoordinatorPuppiesUpdatedEvent(Stub.favoritePuppies123));
    },
    expect: () => <CoordinatorState>[
      CoordinatorPuppiesUpdatedState(Stub.favoritePuppies123)
    ],
  );
}
