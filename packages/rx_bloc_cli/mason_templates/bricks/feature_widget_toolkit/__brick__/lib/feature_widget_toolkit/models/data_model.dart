import 'package:equatable/equatable.dart';
import 'package:widget_toolkit/models.dart';

class DataModel extends PickerItemModel with EquatableMixin {
  DataModel({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;

  @override
  String get itemDisplayName => name;

  @override
  String toString() => name;

  @override
  List<Object?> get props => [name, description];
}
