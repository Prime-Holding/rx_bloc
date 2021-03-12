import 'package:example/models/dummy.dart';
import 'package:example/repositories/dummy_repository.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:rxdart/rxdart.dart';

part 'user_bloc.rxb.g.dart';

/// A contract class containing all events of the UserBloC.
abstract class UserBlocEvents {
  void loadPage({bool reset = false});
}

/// A contract class containing all states of the UserBloC.
abstract class UserBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<String> get errors;

  Stream<List<Dummy>> get paginatedList;

  Stream<bool> get refreshDone;
}

@RxBlocList()
class UserBloc extends $UserBlocList {
  UserBloc(this.repository) : super();

  final DummyRepository repository;

  @override
  Future<List<Dummy>> fetchPaginatedList({required int page}) =>
      repository.fetchPage(page);

  @override
  Stream<String> _mapToErrorsState() =>
      errorState.map((error) => error.toString());

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;
}
