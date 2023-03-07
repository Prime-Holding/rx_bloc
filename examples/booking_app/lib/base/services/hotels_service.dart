import 'package:favorites_advanced_base/core.dart';

import '../repositories/paginated_hotels_repository.dart';

class HotelsService {
  HotelsService(this._hotelsRepository);

  final PaginatedHotelsRepository _hotelsRepository;

  Future<Hotel> hotelById(String hotelId) async =>
      _hotelsRepository.hotelById(hotelId);
}
