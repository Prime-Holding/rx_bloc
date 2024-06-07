// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:rxdart/rxdart.dart';

import '../models/errors/error_model.dart';
import '../models/todo_model.dart';

part 'coordinator_bloc.rxb.g.dart';
part 'coordinator_bloc_extensions.dart';

abstract class CoordinatorEvents {
  void authenticated({required bool isAuthenticated});

  void errorLogged({
    required ErrorModel error,
    String? stackTrace,
  });

  void todoAddedOrUpdated(Result<TodoModel> todo);

  void todoListChanged(Result<List<TodoModel>> todos);

  void todoDeleted(Result<TodoModel> todo);
}

abstract class CoordinatorStates {
  @RxBlocIgnoreState()
  Stream<bool> get isAuthenticated;

  @RxBlocIgnoreState()
  Stream<Result<TodoModel>> get onTodoAddedOrUpdated;

  @RxBlocIgnoreState()
  Stream<Result<TodoModel>> get onTodoDeleted;

  Stream<Result<List<TodoModel>>> get onTodoListChanged;
}

/// The coordinator bloc manages the communication between blocs.
///
/// The goals is to keep all blocs decoupled from each other
/// as the entire communication flow goes through this bloc.
@RxBloc()
class CoordinatorBloc extends $CoordinatorBloc {
  CoordinatorBloc();

  @override
  Stream<bool> get isAuthenticated => _$authenticatedEvent;

  @override
  Stream<Result<TodoModel>> get onTodoAddedOrUpdated =>
      _$todoAddedOrUpdatedEvent;

  @override
  Stream<Result<TodoModel>> get onTodoDeleted => _$todoDeletedEvent;

  @override
  Stream<Result<List<TodoModel>>> _mapToOnTodoListChangedState() =>
      _$todoListChangedEvent.shareReplay(maxSize: 1);
}
