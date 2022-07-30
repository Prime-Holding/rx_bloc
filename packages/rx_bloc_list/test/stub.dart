import 'package:flutter/cupertino.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';

class Stub {
  static const listSize = 100;
  static const pageSize = 10;
  static final pageEmpty = <int>[];
  static final pageOne = <int>[1, 2, 3];
  static final pageTwo = <int>[4, 5, 6];
  static final pageThree = <int>[7, 8, 9];
  static final pageOneTwo = <int>[...Stub.pageOne, ...Stub.pageTwo];
  static final pageOneTwoThree = <int>[
    ...Stub.pageOne,
    ...Stub.pageTwo,
    ...Stub.pageThree,
  ];

  static Stream<Result<PaginatedList<int>>> streamPageError({
    int delay = 2,
    VoidCallback? onEvent,
  }) async* {
    await Future.delayed(Duration(milliseconds: delay));

    if (onEvent != null) {
      onEvent.call();
    }

    yield Result.loading();
    yield Result.error(Exception('error'));
  }

  static Stream<Result<PaginatedList<int>>> steamPage(
    List<int> page, {
    int delay = 2,
    VoidCallback? onEvent,
  }) async* {
    await Future.delayed(Duration(milliseconds: delay));

    if (onEvent != null) {
      onEvent();
    }

    yield Result.loading();
    yield Result.success(PaginatedList(
      list: page,
      pageSize: pageSize,
    ));
  }
}

class IdentifiableModel implements Identifiable {
  @override
  final String id;

  final String value;

  IdentifiableModel(this.id, {String? value}) : value = value ?? '';

  @override
  String toString() => '$id, $value';

  @override
  bool operator ==(Object other) {
    if (other is IdentifiableModel) {
      return other.id == id && other.value == value;
    }

    return false;
  }

  @override
  int get hashCode => id.hashCode ^ value.hashCode;
}
