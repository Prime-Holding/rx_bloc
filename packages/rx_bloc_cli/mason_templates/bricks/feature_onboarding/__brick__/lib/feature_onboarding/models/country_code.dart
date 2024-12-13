import 'package:json_annotation/json_annotation.dart';
import 'package:widget_toolkit/models.dart';

part 'country_code.g.dart';

/// Country code model
@JsonSerializable()
class CountryCodeModel extends PickerItemModel {
  CountryCodeModel({
    required this.code,
    required this.name,
  });

  CountryCodeModel.empty()
      : code = '',
        name = '';

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

  @override
  String? get itemDisplayName => name;

  factory CountryCodeModel.fromJson(Map<String, dynamic> json) =>
      _$CountryCodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$CountryCodeModelToJson(this);
}
