{{> licence.dart }}

import 'dart:async';

import '../../base/data_sources/remote/country_codes_remote_data_source.dart';

class SearchCountryCodeRepository<CountryCodeModel> {
  SearchCountryCodeRepository(this._countryCodesRemoteDataSource) {
    _getCountryCodes();
  }

  final CountryCodesRemoteDataSource _countryCodesRemoteDataSource;
  final _completer = Completer<List<CountryCodeModel>>();

  Future<void> _getCountryCodes() async {
    final countryCodes = await _countryCodesRemoteDataSource.getCountryCodes();
    final data = countryCodes['countryCodes'] as List<CountryCodeModel>? ?? [];
    _completer.complete(data);
  }

  Future<List<CountryCodeModel>> get searchList => _completer.future;

}
