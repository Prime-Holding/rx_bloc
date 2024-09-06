import 'package:booking_app/base/common_blocs/coordinator_bloc.dart';
import 'package:booking_app/base/common_blocs/hotels_extra_details_bloc.dart';
import 'package:booking_app/base/repositories/paginated_hotels_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../stubs.dart';
import 'hotels_extra_details_bloc_test.mocks.dart';

@GenerateMocks([
  PaginatedHotelsRepository,
])
void main() {
  late CoordinatorBlocType coordinatorBloc;
  late PaginatedHotelsRepository hotelsRepositoryMock;
  late HotelsExtraDetailsBloc bloc;

  final hotel = Stub.hotel1;
  final hotelsList = [hotel];

  setUp(() {
    hotelsRepositoryMock = MockPaginatedHotelsRepository();
    coordinatorBloc = CoordinatorBloc();

    bloc = HotelsExtraDetailsBloc(coordinatorBloc, hotelsRepositoryMock);

    when(hotelsRepositoryMock.fetchFullEntities([hotel.id]))
        .thenAnswer((_) async => hotelsList);
  });

  tearDown(() {
    bloc.dispose();
  });

  test('fetchExtraDetails updates _lastFetchedHotels', () async {
    bloc.events.fetchExtraDetails(hotel);

    await expectLater(
      coordinatorBloc.states.onFetchedHotelsWithExtraDetails,
      emitsInOrder([
        hotelsList,
      ]),
    );
  });
}
