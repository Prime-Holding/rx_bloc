{{> licence.dart }}

import 'package:widget_toolkit/edit_address.dart';
import 'package:widget_toolkit/search_picker.dart';

import '../repositories/search_repository.dart';

class SearchService extends SearchPickerService<CountryModel> {
  SearchService(this._searchRepository);

  final SearchCountryRepository _searchRepository;

  @override
  Future<List<CountryModel>> getItems() => _searchRepository.searchList;

  @override
  List<CountryModel> getPlaceholderList() =>
      List.generate(5, (index) => CountryModel.empty());
}
