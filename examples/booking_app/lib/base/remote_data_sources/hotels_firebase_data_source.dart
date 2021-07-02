import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:favorites_advanced_base/core.dart';
import 'package:rx_bloc_list/models.dart';

import 'hotels_data_source.dart';

class HotelsFirebaseDataSource implements HotelsDataSource {
  HotelsFirebaseDataSource() {
    hotelsReference = fireStore.collection('hotels');
    hotelsExtraDetailsReference = fireStore.collection('hotelsExtraDetails');
    hotelsFullExtraDetailsReference =
        fireStore.collection('hotelsFullExtraDetails');
  }

  final fireStore = FirebaseFirestore.instance;
  final fireStorage = firebase_storage.FirebaseStorage.instance;
  QueryDocumentSnapshot? lastFetchedRecord;

  late CollectionReference hotelsReference;
  late CollectionReference hotelsExtraDetailsReference;
  late CollectionReference hotelsFullExtraDetailsReference;

  @override
  Future<Hotel> favoriteHotel(Hotel hotel, {required bool isFavorite}) async {
    await hotelsReference.doc(hotel.id).update({'isFavorite': isFavorite});

    return hotel.copyWith(isFavorite: isFavorite);
  }

  @override
  Future<List<HotelExtraDetails>> fetchExtraDetails(List<String> ids) async {
    final querySnapshot =
        await hotelsExtraDetailsReference.where('hotelId', whereIn: ids).get();
    return querySnapshot.docs.asHotelExtraDetailsList();
  }

  @override
  Future<HotelFullExtraDetails> fetchFullExtraDetails(String hotelId) async {
    final querySnapshot = await hotelsFullExtraDetailsReference
        .where('hotelId', isEqualTo: hotelId)
        .get();
    return querySnapshot.docs.asHotelFullExtraDetailsList().first;
  }

  @override
  Future<List<Hotel>> getFavoriteHotels() async {
    final querySnapshot =
        await hotelsReference.where('isFavorite', isEqualTo: true).get();

    return querySnapshot.docs.asHotelList();
  }

  @override
  Future<PaginatedList<Hotel>> getHotels({
    required int page,
    required int pageSize,
    HotelSearchFilters? filters,
  }) async {
    var querySnapshot = getFirebaseFilteredQuery(filters);

    if (lastFetchedRecord != null && page != 0) {
      querySnapshot = querySnapshot.startAfterDocument(lastFetchedRecord!);
    }

    querySnapshot = querySnapshot.limit(pageSize);

    final snap = await querySnapshot.get();
    lastFetchedRecord = snap.docs.last;
    print(lastFetchedRecord!.id);
    final hotels = snap.docs.asHotelList();

    return PaginatedList(
      list: hotels,
      pageSize: pageSize,
      totalCount: 0,
    );
  }

  @override
  Future<void> seed({multiplier = 100}) async {
    final deleteBatch = FirebaseFirestore.instance.batch();

    // Delete all existing data
    final deleteSnapshotHotels = await hotelsReference.get();
    deleteSnapshotHotels.docs.forEach((document) {
      deleteBatch.delete(document.reference);
    });

    final deleteSnapshotExtraDetailsHotels =
        await hotelsExtraDetailsReference.get();
    deleteSnapshotExtraDetailsHotels.docs.forEach((document) {
      deleteBatch.delete(document.reference);
    });

    final deleteSnapshotFullExtraDetailsHotels =
        await hotelsFullExtraDetailsReference.get();
    deleteSnapshotFullExtraDetailsHotels.docs.forEach((document) {
      deleteBatch.delete(document.reference);
    });

    // Commit batch
    await deleteBatch.commit();

    // Insert records
    final insertBatch = FirebaseFirestore.instance.batch();

    final querySnapshotHotelsExtraDetails =
        await hotelsExtraDetailsReference.get();
    querySnapshotHotelsExtraDetails.docs.map((docs) => docs.reference.delete());

    final querySnapshotFullHotelsExtraDetails =
        await hotelsFullExtraDetailsReference.get();
    querySnapshotFullHotelsExtraDetails.docs
        .map((docs) => docs.reference.delete());

    final hotels = HotelsService.generateEntities(multiplier: multiplier);
    final hotelExtraDetails = HotelsService.generateExtraEntries(
      hotels: hotels,
      multiplier: multiplier,
    );
    final hotelFullExtraDetails = HotelsService.generateFullExtraEntries(
      hotels: hotels,
      multiplier: multiplier,
    );

    // Invalid argument: maximum 500 writes allowed per request
    // const maxFireBaseWritesPerRequest = 3;
    // for (var i = 1; i <= maxFireBaseWritesPerRequest; i++) {}

    hotels.forEach((hotel) {
      final docRef = hotelsReference.doc(hotel.id);
      insertBatch.set(docRef, hotel.toJson());
    });

    hotelExtraDetails.forEach((hotel) {
      final docRef = hotelsExtraDetailsReference.doc(hotel.id);
      insertBatch.set(docRef, hotel.toJson());
    });

    hotelFullExtraDetails.forEach((hotel) {
      final docRef = hotelsFullExtraDetailsReference.doc(hotel.id);
      insertBatch.set(docRef, hotel.toJson());
    });

    await insertBatch.commit();
  }

  Query getFirebaseFilteredQuery(HotelSearchFilters? filters) {
    /// WARNING !!! Firebase allows comparison operators(>, >=, <=, <)
    /// to be applied only on only one field !!!

    if ((filters!.roomCapacity > 0 && filters.personCapacity > 0) ||
        filters.query != '') {
      throw Exception('Firebase does not support multiple filters');
    }

    Query query = hotelsReference;

    // If there are any other filters, apply them
    if (filters.advancedFiltersOn == true) {
      if (filters.dateRange != null) {
        final startAtTimestamp = Timestamp.fromMillisecondsSinceEpoch(
            filters.dateRange!.start.millisecondsSinceEpoch);
        final endAtTimestamp = Timestamp.fromMillisecondsSinceEpoch(
            filters.dateRange!.end.millisecondsSinceEpoch);
        query = query.where(
          'workingDate',
          isGreaterThanOrEqualTo: startAtTimestamp,
        );

        query = query.where(
          'workingDate',
          isLessThanOrEqualTo: endAtTimestamp,
        );
      }

      if (filters.roomCapacity > 0) {
        query = query.where(
          'roomCapacity',
          isEqualTo: filters.roomCapacity,
        );
      }

      if (filters.personCapacity > 0) {
        query = query.where(
          'personCapacity',
          isEqualTo: filters.personCapacity,
        );
      }
    }

    if (filters.sortBy != SortBy.none) {
      if (filters.sortBy == SortBy.priceAsc) {
        query = query.orderBy('perNight');
      }

      if (filters.sortBy == SortBy.priceDesc) {
        query = query.orderBy('perNight', descending: true);
      }

      if (filters.sortBy == SortBy.distanceAsc) {
        query = query.orderBy('dist', descending: true);
      }

      if (filters.sortBy == SortBy.distanceDesc) {
        query = query.orderBy('dist', descending: false);
      }
    }

    return query;
  }
}

extension FireBaseCollection on List<QueryDocumentSnapshot<Object?>> {
  List<Hotel> asHotelList() => map(
        (docs) => Hotel.fromJson(docs.data() as Map<String, dynamic>),
      ).toList();

  List<HotelExtraDetails> asHotelExtraDetailsList() => map(
        (docs) =>
            HotelExtraDetails.fromJson(docs.data() as Map<String, dynamic>),
      ).toList();

  List<HotelFullExtraDetails> asHotelFullExtraDetailsList() => map(
        (docs) =>
            HotelFullExtraDetails.fromJson(docs.data() as Map<String, dynamic>),
      ).toList();
}
