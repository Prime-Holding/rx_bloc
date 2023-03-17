{{> licence.dart }}

import 'package:widget_toolkit/edit_address.dart';

import '../repositories/search_repository.dart';

class CustomEditAddressService<T> extends EditAddressService<T> {
  CustomEditAddressService({
    required this.searchRepository,
  });

  final SearchCountryRepository<T> searchRepository;

  @override
  Future<AddressModel> saveAddress(AddressModel addressModel) async {
    await Future.delayed(const Duration(seconds: 1));
    return addressModel;
  }

  @override
  Future<List<T>> getCountries() async => await searchRepository.searchList;

  @override
  List<T> getCountryPlaceholderList() =>
      List.generate(3, (index) => CountryModel.empty() as T);

  @override
  Future<String> validateCityOnSubmit(String text) async {
    await Future.delayed(const Duration(seconds: 1));
    return super.validateCityOnSubmit(text);
  }
}
