import 'package:widget_toolkit/models.dart';

/// Country code model
class CountryCodeModel extends PickerItemModel {
  CountryCodeModel({
    required this.code,
    required this.name,
  });

  /// Name of the country
  final String name;

  /// Code of the country
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
