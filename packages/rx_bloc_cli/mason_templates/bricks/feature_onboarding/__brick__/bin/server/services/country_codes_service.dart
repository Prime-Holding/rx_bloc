{{> licence.dart }}

import 'package:{{project_name}}/base/models/country_code_model.dart';

import '../repositories/country_codes_repository.dart';

class CountryCodesService {
  CountryCodesService(this._countryCodesRepository);

  final CountryCodesRepository _countryCodesRepository;

  Future<List<CountryCodeModel>> getAllCountryCodes() =>
      _countryCodesRepository.getCountryCodes();
}
