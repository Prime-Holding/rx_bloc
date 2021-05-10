import 'package:bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:bloc_sample/feature_puppy/search/blocs/puppy_list_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:favorites_advanced_base/repositories.dart';

import '../../../stubs.dart';
import 'puppy_list_bloc_test.mocks.dart';

// class MockPuppiesRepository extends Mock implements PuppiesRepository {}

// class MockCoordinatorBloc extends Mock implements CoordinatorBloc {}

@GenerateMocks([
  PuppiesRepository,
  CoordinatorBloc,
])
void main() {
  late MockPuppiesRepository mockRepo;
  late MockCoordinatorBloc mockCoordinatorBloc;
  late PuppyListBloc puppyListBloc;

  setUp(() {
    mockRepo = MockPuppiesRepository();
    mockCoordinatorBloc = MockCoordinatorBloc();
    when(mockCoordinatorBloc.stream).thenAnswer((_) => const Stream.empty());
    puppyListBloc = PuppyListBloc(
      repository: mockRepo,
      coordinatorBloc: mockCoordinatorBloc,
    );
  });

//flutter pub run build_runner build
// After generating puppy_list_bloc_test.mocks.dart change
//change import 'package:image_picker_platform_interface/src/types/picked_file/picked_file.dart'

  blocTest<PuppyListBloc, PuppyListState>(
    'PuppyListBloc FavoritePuppiesUpdatedEvent',
    build: () {
      when(mockRepo.getPuppies(query: ''))
          .thenAnswer((_) async => Stub.favoritePuppies12);
      return puppyListBloc;
    },
    act: (bloc) {
      bloc.add(PuppyListFavoritePuppiesUpdatedEvent(
          favoritePuppies: [Stub.isFavoritePuppy3]));
    },
    expect: () => [
      isA<PuppyListState>(),
      isA<PuppyListState>(),
      isA<PuppyListState>(),
    ],
  );

  blocTest<PuppyListBloc, PuppyListState>('PuppyListBloc searchedPuppiesList ',
      build: () {
        when(mockRepo.getPuppies(query: ''))
            .thenAnswer((_) async => Stub.favoritePuppies123);
        return puppyListBloc;
      },
      verify: (_) => {
            expect(puppyListBloc.state.searchedPuppiesList!.length, 3),
          });

  blocTest<PuppyListBloc, PuppyListState>(
    'PuppyListBloc ReloadPuppiesEvent',
    build: () {
      when(mockRepo.getPuppies(query: ''))
          .thenAnswer((_) async => Stub.favoritePuppies123);
      return puppyListBloc;
    },
    act: (bloc) async {
      bloc.add(ReloadPuppiesEvent());
    },
    expect: () => <PuppyListState>[
      const PuppyListState(
          searchedPuppies: [], status: PuppyListStatus.initial),
      PuppyListState(
          searchedPuppies: Stub.favoritePuppies123,
          status: PuppyListStatus.success),
      PuppyListState(
          searchedPuppies: Stub.favoritePuppies123,
          status: PuppyListStatus.reloading),
      PuppyListState(
          searchedPuppies: Stub.favoritePuppies123,
          status: PuppyListStatus.success),
    ],
  );

  blocTest<PuppyListBloc, PuppyListState>(
    'PuppyListBloc PuppyListFilterUpdatedQueryEvent',
    build: () {
      when(mockRepo.getPuppies(query: ''))
          .thenAnswer((_) async => Stub.queryPuppiesTest2);
      when(mockRepo.getPuppies(query: 'test'))
          .thenAnswer((_) async => Stub.queryPuppiesTest1);
      return puppyListBloc;
    },
    act: (bloc) async {
      bloc.add(PuppyListFilterUpdatedQueryEvent(query: 'test'));
    },
    expect: () => <PuppyListState>[
      const PuppyListState(
        searchedPuppies: [],
        status: PuppyListStatus.initial,
      ),
      PuppyListState(
        searchedPuppies: Stub.queryPuppiesTest2,
        status: PuppyListStatus.success,
      ),
      PuppyListState(
        searchedPuppies: Stub.queryPuppiesTest2,
        status: PuppyListStatus.initial,
      ),
      PuppyListState(
        searchedPuppies: Stub.queryPuppiesTest1,
        status: PuppyListStatus.success,
      ),
    ],
  );

  blocTest<PuppyListBloc, PuppyListState>(
    'PuppyListBloc PuppyListFilterEvent PuppyListFilterUpdatedQueryEvent',
    build: () {
      when(mockRepo.getPuppies(query: ''))
          .thenAnswer((_) async => Stub.queryPuppiesTest2);
      when(mockRepo.getPuppies(query: 'test'))
          .thenAnswer((_) async => Stub.queryPuppiesTest1);
      return puppyListBloc;
    },
    act: (bloc) async {
      bloc
        ..add(PuppyListFilterEvent(query: 'test'))
        ..add(PuppyListFilterUpdatedQueryEvent(query: 'test'));
    },
    expect: () => <PuppyListState>[
      const PuppyListState(
        searchedPuppies: [],
        status: PuppyListStatus.initial,
      ),
      PuppyListState(
        searchedPuppies: Stub.queryPuppiesTest2,
        status: PuppyListStatus.success,
      ),
      PuppyListState(
        searchedPuppies: Stub.queryPuppiesTest2,
        status: PuppyListStatus.initial,
      ),
      PuppyListState(
        searchedPuppies: Stub.queryPuppiesTest1,
        status: PuppyListStatus.success,
      ),
    ],
  );

  blocTest<PuppyListBloc, PuppyListState>(
    'PuppyListBloc throws from getPuppies() and returns status failure',
    build: () {
      when(mockRepo.getPuppies(query: '')).thenThrow(Stub.testErr);
      return puppyListBloc;
    },
    expect: () => <PuppyListState>[
      const PuppyListState(
        searchedPuppies: [],
        status: PuppyListStatus.initial,
      ),
      const PuppyListState(
        searchedPuppies: [],
        status: PuppyListStatus.failure,
      ),
    ],
  );
}
