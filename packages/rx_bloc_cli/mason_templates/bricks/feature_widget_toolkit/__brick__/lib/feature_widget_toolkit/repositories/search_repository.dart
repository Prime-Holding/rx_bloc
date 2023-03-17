{{> licence.dart }}

import 'package:widget_toolkit/edit_address.dart';

class SearchCountryRepository<T> {
  Future<List<T>> get searchList => Future.delayed(
        const Duration(seconds: 1),
        () => _countriesList
            .map((country) =>
                CountryModel(countryCode: 'US', countryName: country) as T)
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
}
