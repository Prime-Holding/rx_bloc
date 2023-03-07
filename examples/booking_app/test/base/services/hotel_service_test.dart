import 'package:booking_app/base/repositories/paginated_hotels_repository.dart';
import 'package:booking_app/base/services/hotels_service.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../feature_hotel_favorites/blocs/hotel_favorites_test.mocks.dart';
import '../../stubs.dart';

@GenerateMocks([PaginatedHotelsRepository])
void main() {
  late MockPaginatedHotelsRepository paginatedHotelsRepositoryMock;

  late HotelsService hotelsService;

  setUp(() {
    paginatedHotelsRepositoryMock = MockPaginatedHotelsRepository();
    when(paginatedHotelsRepositoryMock.hotelById(Stub.hotel1.id))
        .thenAnswer((_) => Future(() => Stub.hotel1));

    hotelsService = HotelsService(paginatedHotelsRepositoryMock);
  });

  group('hotel by id test', () {
    test('Get hotel by id success', () async {
      final result = await hotelsService.hotelById(Stub.hotel1.id);
      expect(result, isA<Hotel>());
    });
  });
}
