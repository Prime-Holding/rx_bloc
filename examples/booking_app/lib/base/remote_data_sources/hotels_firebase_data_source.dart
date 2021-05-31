import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:favorites_advanced_base/core.dart';

class HotelsFirebaseDataSource implements HotelsDataSource {
  factory HotelsFirebaseDataSource() {
    _instance ??= HotelsFirebaseDataSource._();

    return _instance!;
  }

  HotelsFirebaseDataSource._() {
    hotelsReference = fireStore.collection('hotels');
    hotelsExtraDetailsReference = fireStore.collection('hotelsExtraDetails');
    hotelsFullExtraDetailsReference =
        fireStore.collection('hotelsFullExtraDetails');
  }

  static HotelsFirebaseDataSource? _instance;
  final fireStore = FirebaseFirestore.instance;
  final fireStorage = firebase_storage.FirebaseStorage.instance;

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
    print(ids);
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
  Future<List<Hotel>> getHotels({HotelSearchFilters? filters}) async {
    final querySnapshot = await hotelsReference.get();
    return querySnapshot.docs.asHotelList();
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

    await deleteBatch.commit();

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
    /// to be applied only on one field !!!

    final query = hotelsReference;

    // If there are any other filters, apply them
    if (filters?.advancedFiltersOn ?? false) {
      if (filters!.dateRange != null) {
        final startAtTimestamp = Timestamp.fromMillisecondsSinceEpoch(
            filters.dateRange!.start.millisecondsSinceEpoch);
        return query.where(
          'startWorkDate',
          isLessThanOrEqualTo: startAtTimestamp,
        );
      }
      if (filters.roomCapacity > 0) {
        return query.where(
          'roomCapacity',
          isGreaterThanOrEqualTo: filters.roomCapacity,
        );
      }
      if (filters.personCapacity > 0) {
        return query.where(
          'personCapacity',
          isGreaterThanOrEqualTo: filters.roomCapacity,
        );
      }
    }

    return query;
  }

  @override
  Future<String> fetchFeaturedImage(Hotel hotel) =>
      fireStorage.ref().child('images').child(hotel.image).getDownloadURL();
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
