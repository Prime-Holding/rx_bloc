import 'package:favorites_advanced_base/src/local_data_sources/stub_data_source.dart';

import '../../models.dart';

class HotelsService {
  static List<Hotel> generateEntities({required int multiplier}) =>
      List.generate(
              multiplier,
              (index) => [...StubDataSource.hotelsDB]
                  .map(
                    (hotel) => hotel.copyWith(
                      id: '$index-${hotel.id}',
                      isFavorite: false,
                    ),
                  )
                  .toList())
          .expand((element) => element)
          .toList()
          .asMap()
          .entries
          .map<Hotel>(
            (entry) => entry.value
                .copyWith(title: '${entry.key} - ${entry.value.title}'),
          )
          .toList();

  static List<HotelExtraDetails> generateExtraEntries({
    required List<Hotel> hotels,
    required int multiplier,
  }) =>
      List.generate(
              multiplier,
              (index) => [...StubDataSource.hotelsExtraDetailsDB]
                  .map(
                    (hotelExtraDetails) => hotelExtraDetails.copyWith(
                      id: '$index-${hotelExtraDetails.id}',
                    ),
                  )
                  .toList())
          .expand((element) => element)
          .toList()
          .asMap()
          .entries
          .map<HotelExtraDetails>(
            (entry) => entry.value.copyWith(hotelId: [hotels[entry.key].id]),
          )
          .toList();

  static List<HotelFullExtraDetails> generateFullExtraEntries({
    required List<Hotel> hotels,
    required int multiplier,
  }) =>
      List.generate(
              multiplier,
              (index) => [...StubDataSource.hotelsFullExtraDetailsDB]
                  .map(
                    (hotelFullExtraDetails) => hotelFullExtraDetails.copyWith(
                      id: '$index-${hotelFullExtraDetails.id}',
                    ),
                  )
                  .toList())
          .expand((element) => element)
          .toList()
          .asMap()
          .entries
          .map<HotelFullExtraDetails>(
            (entry) => entry.value.copyWith(hotelId: [hotels[entry.key].id]),
          )
          .toList();
}
