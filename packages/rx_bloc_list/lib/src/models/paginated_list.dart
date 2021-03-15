import 'dart:async';
import 'dart:collection';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'paginated_list_extensions.dart';

class PaginatedList<E> extends ListBase<E> {
  PaginatedList({
    required this.list,
    required this.pageSize,
    this.isLoading = false,
    this.error,
    this.totalCount,
  });

  final Exception? error;
  final bool isLoading;
  final List<E> list;
  final int? totalCount;
  final int pageSize;

  @override
  set length(int newLength) => list.length = newLength;

  @override
  int get length => list.length;

  int get itemCount => isNextPageLoading ? list.length + 1 : list.length;

  @override
  E operator [](int index) => list[index];

  @override
  void operator []=(int index, E value) {
    list[index] = value;
  }

  int get pageNumber => (length / pageSize).ceil();

  bool get hasNextPage => totalCount == null || list.length < totalCount!;

  bool get isInitialLoading => isLoading && list.isEmpty;

  bool get isNextPageLoading => isLoading && list.isNotEmpty;

  PaginatedList<E> copyWith({
    List<E>? list,
    bool? isLoading,
    int? totalCount,
    Exception? error,
    int? pageSize,
  }) =>
      PaginatedList(
        list: list ?? this.list,
        isLoading: isLoading ?? this.isLoading,
        totalCount: totalCount ?? this.totalCount,
        error: error ?? this.error,
        pageSize: pageSize ?? this.pageSize,
      );
}
