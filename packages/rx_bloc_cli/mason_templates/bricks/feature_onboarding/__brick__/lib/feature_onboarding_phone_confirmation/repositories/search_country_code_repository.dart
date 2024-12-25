{{> licence.dart }}

import 'dart:async';

import '../../base/data_sources/remote/country_codes_remote_data_source.dart';
import '../../base/models/country_code_model.dart';

class SearchCountryCodeRepository {
  SearchCountryCodeRepository(this._countryCodesRemoteDataSource) {
    fetchCountryCodes(force: true);
  }

  final CountryCodesRemoteDataSource _countryCodesRemoteDataSource;
  late Completer<List<CountryCodeModel>> _completer;

  Future<List<CountryCodeModel>> fetchCountryCodes({bool force = false}) async {
    if (force) {
      _completer = Completer<List<CountryCodeModel>>();
      final countryCodes =
          await _countryCodesRemoteDataSource.getCountryCodes();
      final data = countryCodes['countryCodes'] ?? [];
      _completer.complete(data);
    }

    return _completer.future;
  }
}
