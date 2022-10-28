import 'package:equatable/equatable.dart';

class CapacityFilterData with EquatableMixin {
  CapacityFilterData({
    required this.rooms,
    required this.persons,
    required this.text,
  });

  final int rooms;
  final int persons;
  final String text;

  @override
  List<Object?> get props => [rooms, persons, text];
}
