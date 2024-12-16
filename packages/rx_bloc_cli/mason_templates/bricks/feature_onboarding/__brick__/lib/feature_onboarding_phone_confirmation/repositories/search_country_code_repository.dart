{{> licence.dart }}

import 'dart:async';

import '../../base/data_sources/remote/country_codes_remote_data_source.dart';
import '../../base/models/country_code_model.dart';

class SearchCountryCodeRepository<T> {
  SearchCountryCodeRepository(this._countryCodesRemoteDataSource) {
    _getCountryCodes();
  }

  final CountryCodesRemoteDataSource _countryCodesRemoteDataSource;
  final _completer = Completer<List<CountryCodeModel>>();

  Future<void> _getCountryCodes() async {
    final countryCodes = await _countryCodesRemoteDataSource.getCountryCodes();
    _completer.complete(countryCodes['countryCodes']);
  }

  Future<List<T>> get searchList => _completer.future as Future<List<T>>;
}
