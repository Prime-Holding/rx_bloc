{{> licence.dart }}

import 'package:widget_toolkit/edit_address.dart';

import '../../assets.dart';
import '../../base/models/errors/error_model.dart';

class AuthMatrixEditAddressService extends EditAddressService<CountryModel> {
  AuthMatrixEditAddressService();

  Future<List<CountryModel>> get searchList => Future.delayed(
        const Duration(seconds: 1),
        () => _countriesList
            .map((country) =>
                CountryModel(countryCode: 'US', countryName: country))
            .toList(),
      );

  final _countriesList = [
    'Angola',
    'Bulgaria',
    'Cuba',
    'Egypt',
    'Italy',
    'Angola',
    'Bulgaria',
    'Cuba',
    'Egypt',
    'Italy',
    'Angola',
    'Bulgaria',
    'Cuba',
    'Egypt',
    'Italy'
  ];

  @override
  Future<AddressModel> saveAddress(AddressModel addressModel) async {
    await Future.delayed(const Duration(seconds: 1));
    return addressModel;
  }

  @override
  Future<List<CountryModel>> getCountries() => searchList;

  @override
  List<CountryModel> getCountryPlaceholderList() =>
      List.generate(3, (index) => CountryModel.empty());

  @override
  Future<String> validateCityOnSubmit(String text) async {
    if (text.trim().isEmpty) {
      throw FieldErrorModel<String>(
        errorKey: I18nErrorKeys.tooShort,
        fieldValue: text,
      );
    }
    return text;
  }

  @override
  Future<String> validateStreetOnSubmit(String text) async {
    if (text.trim().isEmpty) {
      throw FieldErrorModel<String>(
        errorKey: I18nErrorKeys.tooShort,
        fieldValue: text,
      );
    }
    return text;
  }

  @override
  void validateCityOnType(String text) {
    if (text.trim().isEmpty) {
      throw FieldErrorModel<String>(
        errorKey: I18nErrorKeys.tooShort,
        fieldValue: text,
      );
    }
  }

  @override
  void validateStreetOnType(String text) {
    if (text.trim().isEmpty) {
      throw FieldErrorModel<String>(
        errorKey: I18nErrorKeys.tooShort,
        fieldValue: text,
      );
    }
  }
}
