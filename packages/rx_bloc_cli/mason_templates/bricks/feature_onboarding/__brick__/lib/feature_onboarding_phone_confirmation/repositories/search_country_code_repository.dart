{{> licence.dart }}

import 'dart:async';

import '../../base/data_sources/remote/country_codes_remote_data_source.dart';
import '../../base/models/country_code_model.dart';

class SearchCountryCodeRepository {
  SearchCountryCodeRepository(this._countryCodesRemoteDataSource) {
    _getCountryCodes();
  }

  final CountryCodesRemoteDataSource _countryCodesRemoteDataSource;
  final _completer = Completer<List<CountryCodeModel>>();

  Future<void> _getCountryCodes() async {
    final countryCodes = await _countryCodesRemoteDataSource.getCountryCodes();
    final data = countryCodes['countryCodes'] ?? [];
    _completer.complete(data);
  }

  Future<List<CountryCodeModel>> get searchList => _completer.future;
}
