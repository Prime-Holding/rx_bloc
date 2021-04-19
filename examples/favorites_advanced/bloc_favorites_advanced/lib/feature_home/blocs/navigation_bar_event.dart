part of 'navigation_bar_bloc.dart';

@immutable
class NavigationBarEvent {
  const NavigationBarEvent(this.itemType);

  final NavigationItemType itemType;
}
