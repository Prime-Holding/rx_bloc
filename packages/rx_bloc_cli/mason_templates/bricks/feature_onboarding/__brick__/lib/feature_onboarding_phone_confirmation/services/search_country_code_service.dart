import 'package:widget_toolkit/search_picker.dart';

import '../../base/models/country_code_model.dart';
import '../repositories/search_country_code_repository.dart';

class SearchCountryCodeService extends SearchPickerService<CountryCodeModel> {
  SearchCountryCodeService(this._searchRepository);

  final SearchCountryCodeRepository _searchRepository;

  @override
  Future<List<CountryCodeModel>> getItems() => _searchRepository.searchList;

  @override
  List<CountryCodeModel> getPlaceholderList() =>
      List.generate(5, (index) => CountryCodeModel.empty());
}
