{{> licence.dart }}

class ItemModel {
  ItemModel({
    required this.id,
    required this.name,
    required this.description,
  });

  final String id;
  final String name;
  final String description;

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };
}