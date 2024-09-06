import 'package:booking_app/base/repositories/paginated_hotels_repository.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../stubs.dart';
import 'paginated_hotels_repository_test.mocks.dart';

@GenerateMocks([
  HotelsRepository,
])
void main() {
  late MockHotelsRepository mockHotelsRepository;
  late PaginatedHotelsRepository paginatedHotelsRepository;

  setUp(() {
    mockHotelsRepository = MockHotelsRepository();
    paginatedHotelsRepository = PaginatedHotelsRepository(mockHotelsRepository);
  });

  test('getFavoriteHotelsPaginated returns correct PaginatedList', () async {
    final hotels = [Stub.hotel1, Stub.hotel2, Stub.hotel3];
    when(mockHotelsRepository.getFavoriteHotels())
        .thenAnswer((_) async => hotels);

    final result = await paginatedHotelsRepository.getFavoriteHotelsPaginated(
      pageSize: 2,
      page: 1,
    );

    expect(result.list, [Stub.hotel1, Stub.hotel2]);
    expect(result.pageSize, 2);
    expect(result.totalCount, 3);
  });

  test('getHotelsPaginated returns correct PaginatedList', () async {
    final filters = HotelSearchFilters();
    final hotels = [Stub.hotel1, Stub.hotel2, Stub.hotel3, Stub.hotel4];
    when(mockHotelsRepository.getHotels(filters: filters))
        .thenAnswer((_) async => hotels);

    final result = await paginatedHotelsRepository.getHotelsPaginated(
      filters: filters,
      pageSize: 2,
      page: 2,
    );

    expect(result.list, [Stub.hotel3, Stub.hotel4]);
    expect(result.pageSize, 2);
    expect(result.totalCount, 4);
  });

  test('favoriteHotel returns correct Hotel', () async {
    final hotel = Stub.hotel1;
    when(mockHotelsRepository.favoriteHotel(hotel, isFavorite: true))
        .thenAnswer((_) async => hotel);

    final result =
        await paginatedHotelsRepository.favoriteHotel(hotel, isFavorite: true);

    expect(result, hotel);
  });

  test('fetchFullEntities returns correct list of hotels', () async {
    final ids = ['1', '2', '3'];
    final hotels = [Stub.hotel1, Stub.hotel2, Stub.hotel3];
    when(mockHotelsRepository.fetchFullEntities(ids, allProps: true))
        .thenAnswer((_) async => hotels);

    final result =
        await paginatedHotelsRepository.fetchFullEntities(ids, allProps: true);

    expect(result, hotels);
  });

  test('hotelById returns correct Hotel', () async {
    const hotelId = '1';
    final hotel = Stub.hotel1;
    when(mockHotelsRepository.hotelById(hotelId))
        .thenAnswer((_) async => hotel);

    final result = await paginatedHotelsRepository.hotelById(hotelId);

    expect(result, hotel);
  });
}
