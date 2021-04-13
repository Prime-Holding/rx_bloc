import 'package:flutter/cupertino.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';

class Stub {
  static final listSize = 100;
  static final pageSize = 10;
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
