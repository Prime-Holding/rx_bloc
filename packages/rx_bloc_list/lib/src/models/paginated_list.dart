import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'paginated_list_extensions.dart';

/// PaginatedList class is an extension on the list class that allows for easier
/// data manipulation and work with paginated data.
///
/// The [PaginatedList] class requires a [list] of data and a [pageSize] integer
/// which will allow the list to be separated into multiple pages.
///
/// If the number of total items is known in advance, it can be specified as the
/// [totalCount] parameter.
///
/// The [isLoading] parameter represents whether the data is loading or has
/// loaded. This can be useful when building ui-related refresh states.
///
/// If an error occurs while using the paginated list, it can be stored inside
/// the [error] parameter. Usually you would store any data fetching or related
/// errors.
///
/// The number of loaded pages can be accessed any time by referring to the
/// [pageNumber] value. Please note, that the number of pages is affected by the
/// actual [length] of the list and the [pageSize].
///
/// Unlike the [length] of the list which is the actual number of items in the
/// list, the [itemCount] represents the number of items that should be rendered
/// on screen. The [itemCount] is equal to [length], unless the next page is
/// loading. Then, the [itemCount] also accounts for the loading widget at the
/// bottom of the list in case there are more items to be loaded.
///
/// In order to tell whether there is a next page to be loaded, [hasNextPage]
/// can be used for that case.
///
/// Getters [isInitialLoading] and [isNextPageLoading] reflect the current
/// loading state of the list. If there is no data and [isLoading] is true, the
/// getter [isInitialLoading] will return true. Similarly, if [isLoading] is
/// true and we can load a new page, the getter [isNextPageLoading] will return
/// true.
///
class PaginatedList<E> extends ListBase<E> {
  /// PaginatedList constructor
  PaginatedList({
    required this.list,
    required this.pageSize,
    this.error,
    this.totalCount,
    this.isLoading = false,
    bool isInitialized = false,
  }) : _isInitialized = isInitialized;

  /// The list containing the actual data.
  final List<E> list;

  /// The number of elements per one page.
  final int pageSize;

  /// If an exception is thrown, the [error] field will capture it.
  final Exception? error;

  /// Optional field containing total number of elements (if known).
  final int? totalCount;

  /// Indicates whether the paginated list is loading or not.
  final bool isLoading;

  /// Indicates whether the paginated list has been populated with data
  final bool _isInitialized;

  /// Temporary list which stores data in between refreshes
  List<E> _backupList = [];

  /// Setter for the length of the list.
  @override
  set length(int newLength) => list.length = newLength;

  /// Returns the actual list length.
  @override
  int get length => list.length;

  /// Returns the number of items in a list. When loading a new page, the number
  /// of items is increased by one, which can be used to represent the bottom
  /// loading widget.
  int get itemCount =>
      hasNextPage && isNextPageLoading ? list.length + 1 : list.length;

  /// The number of loaded pages.
  int get pageNumber => list.isNotEmpty ? (length / pageSize).ceil() : 0;

  /// The next page to load
  int get pageToLoad => pageNumber;

  /// Getter used for telling us whether there is a new page to load.
  bool get hasNextPage => totalCount == null || list.length < totalCount!;

  /// Getter used for telling us whether this the initial data being loaded.
  bool get isInitialLoading => isLoading && list.isEmpty && !_isInitialized;

  /// Getter for telling us whether we are loading a new page.
  bool get isNextPageLoading => isLoading && list.isNotEmpty;

  @override
  E operator [](int index) => list[index];

  @override
  void operator []=(int index, E value) {
    list[index] = value;
  }

  /// Returns a modified version of the current PaginatedList
  PaginatedList<E> copyWith({
    List<E>? list,
    bool? isLoading,
    int? totalCount,
    Exception? error,
    int? pageSize,
    bool? isInitialized,
  }) =>
      PaginatedList(
        list: list ?? this.list,
        isLoading: isLoading ?? this.isLoading,
        totalCount: totalCount ?? this.totalCount,
        pageSize: pageSize ?? this.pageSize,
        isInitialized: isInitialized ?? _isInitialized,
        error: error,
      ).._backupList = _backupList;

  /// Returns element at given index. If element outside bound, null is returned
  E? getItem(int index) => (index >= length || index < 0) ? null : list[index];

  /// Resets the list data
  void reset({bool hard = false}) {
    _backupList.clear();

    if (hard == false) {
      _backupList.addAll(list);
    }

    length = 0;
  }

  @override
  bool operator ==(other) =>
      other is PaginatedList<E> &&
      other.pageSize == pageSize &&
      other.error == error &&
      other.totalCount == totalCount &&
      other.isLoading == isLoading &&
      other.list == list;

  @override
  int get hashCode =>
      pageSize.hashCode ^
      error.hashCode ^
      totalCount.hashCode ^
      isLoading.hashCode ^
      _isInitialized.hashCode ^
      list.hashCode;

  @override
  String toString() =>
      '{pageSize: $pageSize, error: $error, totalCount: $totalCount, '
      'isLoading: $isLoading, list: $list}';
}
