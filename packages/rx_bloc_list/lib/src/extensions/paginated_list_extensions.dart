import 'package:flutter/widgets.dart';

import '../models/paginated_list.dart';

/// PaginatedList stream extensions
extension PaginatedListStreamExtensions<T> on Stream<PaginatedList<T>> {
  /// Awaited value of this method will return once the data has been loaded or
  /// refreshed.
  Future<void> waitToLoad() async {
    await firstWhere((list) => list.isLoading);
    await firstWhere((list) => !list.isLoading);
  }
}

/// PaginatedList snapshot extensions
extension PaginatedListSnapshotExt<T> on AsyncSnapshot<PaginatedList<T>> {
  /// Is this the initial loading of the snapshot data
  bool get isInitialLoading => !hasData || data!.isInitialLoading;

  /// Is the next page loading
  bool get isNextPageLoading => !hasData || data!.isNextPageLoading;

  /// Is the data loading
  bool get isLoading => !hasData || data!.isLoading;

  /// Is the [data] an [error]
  bool get hasPageError => hasData && data!.error != null;

  /// Returns the element of the snapshot or null (if element outside range),
  /// assuming the snapshot data exists.
  T? getItem(int index) => data!.getItem(index);

  /// Returns the number of items from the snapshot, assuming the data exists.
  int get itemCount => data!.itemCount;

  /// Returns the current page number, assuming the data exists.
  int get pageNumber => data!.pageNumber;
}
