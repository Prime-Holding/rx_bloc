import 'package:equatable/equatable.dart';

enum NavigationItemType { search, favorites }

class NavigationItem with EquatableMixin {
  const NavigationItem({
    required this.type,
    required this.isSelected,
  });

  final NavigationItemType type;
  final bool isSelected;

  @override
  List<Object?> get props => [type, isSelected];
}
