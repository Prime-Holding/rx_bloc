part of 'navigation_bar_bloc.dart';

@immutable
class NavigationBarState extends Equatable {
  const NavigationBarState({
    required this.title,
    required this.items,
    required this.selectedItem,
  });

  final String title;
  final List<NavigationItem> items;
  final NavigationItem selectedItem;

  @override
  List<Object> get props => [title, items, selectedItem];
}
