part of 'navigation_bar_bloc.dart';

@immutable
class NavigationBarState extends Equatable {
  final String title;
  final List<NavigationItem> items;
  final NavigationItem selectedItem;

  NavigationBarState({
    @required this.title,
    @required this.items,
    @required this.selectedItem,
  });

  @override
  List<Object> get props => [title, items, selectedItem];
}
