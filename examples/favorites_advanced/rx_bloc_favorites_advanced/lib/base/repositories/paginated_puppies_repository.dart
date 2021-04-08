import 'package:favorites_advanced_base/core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rx_bloc_list/models.dart';

class PaginatedPuppiesRepository implements PuppiesRepository {
  PaginatedPuppiesRepository(PuppiesRepository repository)
      : _repository = repository;

  final PuppiesRepository _repository;

  Future<PaginatedList<Puppy>> getFavoritePuppiesPaginated({
    required int pageSize,
    required int page,
  }) async =>
      PaginatedList(
        list: (await getFavoritePuppies()).getPage(
          pageSize: pageSize,
          page: page,
        ),
        pageSize: pageSize,
      );

  Future<PaginatedList<Puppy>> getPuppiesPaginated({
    required String query,
    required int pageSize,
    required int page,
  }) async =>
      PaginatedList(
        list: (await getPuppies(query: query)).getPage(
          pageSize: pageSize,
          page: page,
        ),
        pageSize: pageSize,
      );

  @override
  Future<List<Puppy>> getFavoritePuppies() => _repository.getFavoritePuppies();

  @override
  Future<List<Puppy>> getPuppies({String query = ''}) =>
      _repository.getPuppies(query: query);

  @override
  Future<Puppy> favoritePuppy(Puppy puppy, {required bool isFavorite}) =>
      _repository.favoritePuppy(puppy, isFavorite: isFavorite);

  @override
  Future<List<Puppy>> fetchFullEntities(List<String> ids) =>
      _repository.fetchFullEntities(ids);

  @override
  Future<PickedFile?> pickPuppyImage(ImagePickerAction source) =>
      pickPuppyImage(source);

  @override
  Future<Puppy> updatePuppy(String puppyId, Puppy newValue) =>
      _repository.updatePuppy(puppyId, newValue);
}

extension _PuppyList on List<Puppy> {
  List<Puppy> getPage({
    required int pageSize,
    required int page,
  }) {
    final startRange = (page - 1) * pageSize;
    final endRange = startRange + pageSize;
    return getRange(startRange, endRange > length ? length : endRange).toList();
  }
}
