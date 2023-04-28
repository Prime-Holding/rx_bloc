import 'package:json_annotation/json_annotation.dart';

part 'model_with_factories.g.dart';

@JsonSerializable()
class ModelWithFactories {
    ModelWithFactories({//some fields
    })

  factory Model.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModelToJson(this);
}


enum ModelWithFactoriesEnum {

}