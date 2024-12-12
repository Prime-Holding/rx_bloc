import 'package:widget_toolkit/models.dart';

/// Country code model
class CountryCodeModel extends PickerItemModel {
  CountryCodeModel({
    required this.code,
    required this.name,
  });

  /// Name of the country
  final String name;

  /// Country code number (without the plus sign)
  ///
  /// The value is a number representing the unique code of a country. This
  /// value is usually prefixed by a plus sign (+).
  ///
  /// Example:
  /// USA: 1  => +1
  /// UK: 44  => +44
  /// UAE: 971 => +971
  /// Bahamas: 1-242 => +1-242
  final String code;

  CountryCodeModel.empty()
      : code = '',
        name = '';

  factory CountryCodeModel.fromJson(Map<String, dynamic> json) {
    return CountryCodeModel(
      code: json['code'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
    };
  }

  @override
  String? get itemDisplayName => name;
}
