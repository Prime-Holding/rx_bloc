part of 'navigation_bar_bloc.dart';

extension _Mapper on Stream<List<NavigationItem>> {
  /// Map to a representable string based on [NavigationItemType]
  Stream<String> mapToSelectedTitle() =>
      selected.map((item) => item.type.asTitle());

  /// Map to the selected [NavigationItem] based on [NavigationItem.isSelected]
  Stream<NavigationItem> get selected => map(
        (items) => items.firstWhere(
          (item) => item.isSelected,
          orElse: () => items.first,
        ),
      );
}

extension _ListenToUpdateItems on Stream<NavigationItemType> {
  /// Listen for change in this stream and update the given [items] accordingly.
  StreamSubscription<List<NavigationItem>> updateItems(
    BehaviorSubject<List<NavigationItem>> items,
  ) =>
      map((selectedItem) => items.value
          .map((item) => item.copyWith(isSelected: selectedItem == item.type))
          .toList()).bind(items);
}
