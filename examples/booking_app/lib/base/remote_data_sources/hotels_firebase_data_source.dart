import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorites_advanced_base/core.dart';

class HotelsFirebaseDataSource implements HotelsDataSource {
  factory HotelsFirebaseDataSource() {
    _instance ??= HotelsFirebaseDataSource._();

    return _instance!;
  }

  HotelsFirebaseDataSource._() {
    hotelsReference = fireStore.collection('hotels');
    hotelsExtraDetailsReference = fireStore.collection('hotelsExtraDetails');
  }

  static HotelsFirebaseDataSource? _instance;
  final fireStore = FirebaseFirestore.instance;

  late CollectionReference hotelsReference;
  late CollectionReference hotelsExtraDetailsReference;

  @override
  Future<Hotel> favoriteHotel(Hotel hotel, {required bool isFavorite}) async {
    await hotelsReference.doc(hotel.id).update({'isFavorite': isFavorite});

    return hotel.copyWith(isFavorite: isFavorite);
  }

  @override
  Future<List<Hotel>> fetchFullEntities(
    List<String> ids, {
    bool allProps = false,
  }) async {
    final querySnapshot = await hotelsReference.get();

    querySnapshot.docs.map((e) => print(e.data()));

    return [];
  }

  @override
  Future<List<Hotel>> getFavoriteHotels() async {
    final querySnapshot =
        await hotelsReference.where('isFavorite', isEqualTo: true).get();

    querySnapshot.docs.map((e) => print(e.data()));

    return [];
  }

  @override
  Future<List<Hotel>> getHotels({HotelSearchFilters? filters}) async {
    final querySnapshot = await hotelsReference.get();

    querySnapshot.docs.map((e) => print(e.data()));

    return [];
  }
}
