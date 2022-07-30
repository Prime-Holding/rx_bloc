import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

/// App entry
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RxBlocList Example',
      home: RxBlocProvider<UserBlocType>(
        create: (context) => UserBloc(repository: UserRepository()),
        child: const PaginatedListPage(),
      ),
    );
  }
}

/// region Paginated List page

class PaginatedListPage extends StatelessWidget {
  const PaginatedListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: RxPaginatedBuilder<UserBlocType, User>.withRefreshIndicator(
            state: (bloc) => bloc.states.paginatedList,
            onBottomScrolled: (bloc) => bloc.events.loadPage(),
            onRefresh: (bloc) async {
              bloc.events.loadPage(reset: true);
              return bloc.states.refreshDone;
            },
            buildSuccess: (context, list, bloc) => ListView.builder(
              itemBuilder: (context, index) {
                final user = list.getItem(index);

                if (user == null) {
                  return const YourProgressIndicator();
                }

                return YourListTile(user: user);
              },
              itemCount: list.itemCount,
            ),
            buildLoading: (context, list, bloc) =>
                const YourProgressIndicator(),
            buildError: (context, list, bloc) =>
                YourErrorWidget(error: list.error!),
          ),
        ),
      );
}

/// App specific list tile
class YourListTile extends StatelessWidget {
  /// Default constructor
  const YourListTile({
    required this.user,
    Key? key,
  }) : super(key: key);

  /// The model
  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(user.id.toString()),
        ),
        title: Text(user.name),
      ),
    );
  }
}

/// App specific error widget
class YourErrorWidget extends StatelessWidget {
  /// Default constructor
  const YourErrorWidget({
    required this.error,
    Key? key,
  }) : super(key: key);

  /// The error presented in the widget
  final Exception error;

  @override
  Widget build(BuildContext context) => Text(error.toString());
}

/// App specific progress indicator
class YourProgressIndicator extends StatelessWidget {
  /// Default constructor
  const YourProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: CircularProgressIndicator(),
        ),
      );
}

/// endregion

/// region User Bloc

/// A contract class containing all events of the UserBloC.
abstract class UserBlocEvents {
  /// Load the next page of data. If reset is true, refresh the data and load
  /// the very first page
  void loadPage({bool reset = false});
}

/// A contract class containing all states of the UserBloC.
abstract class UserBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<String> get errors;

  /// The paginated list data
  Stream<PaginatedList<User>> get paginatedList;

  /// Returns when the data refreshing has completed
  @RxBlocIgnoreState()
  Future<void> get refreshDone;
}

/// User Bloc
@RxBloc()
class UserBloc extends $UserBloc {
  /// UserBloc default constructor
  UserBloc({required UserRepository repository}) {
    _$loadPageEvent
        // Start the data fetching immediately when the page loads
        .startWith(true)
        .fetchData(repository, _paginatedList)
        // Enable state handling by the current bloc
        .setResultStateHandler(this)
        // Merge the data in the _paginatedList
        .mergeWithPaginatedList(_paginatedList)
        .bind(_paginatedList)
        // Make sure we dispose the subscription
        .disposedBy(_compositeSubscription);
  }

  /// Internal paginated list stream
  final _paginatedList = BehaviorSubject<PaginatedList<User>>.seeded(
    PaginatedList<User>(
      list: [],
      pageSize: 50,
    ),
  );

  @override
  Future<void> get refreshDone async => _paginatedList.waitToLoad();

  @override
  Stream<PaginatedList<User>> _mapToPaginatedListState() => _paginatedList;

  @override
  Stream<String> _mapToErrorsState() =>
      errorState.map((error) => error.toString());

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  /// Disposes of all streams to prevent memory leaks
  @override
  void dispose() {
    _paginatedList.close();
    super.dispose();
  }
}

/// Utility extensions for the Stream<bool> streams used within User Bloc
extension UserBlocStreamExtensions on Stream<bool> {
  /// Fetches appropriate data from the repository
  Stream<Result<PaginatedList<User>>> fetchData(
    UserRepository _repository,
    BehaviorSubject<PaginatedList<User>> _paginatedList,
  ) =>
      switchMap(
        (reset) {
          if (reset) _paginatedList.value.reset();
          return _repository
              .fetchPage(
                _paginatedList.value.pageNumber + 1,
                _paginatedList.value.pageSize,
              )
              .asResultStream();
        },
      );
}

/// endregion

/// region Models and repositories

class User {
  /// User constructor
  User({
    required this.id,
    this.name = '',
  });

  /// The id of the user
  final int id;

  /// The name of the user
  final String name;
}

/// User repository which represents a mock repository which simulates retrieval
/// of mock data, adding a custom delay.
class UserRepository {
  /// Fetches a specific page from the repository with the given size
  Future<PaginatedList<User>> fetchPage(int page, int pageSize) async {
    await Future.delayed(const Duration(seconds: 2));

    if (page > 10) {
      return PaginatedList(
        list: [],
        pageSize: pageSize,
      );
    }

    return PaginatedList(
      list: List.generate(
        pageSize,
        (index) {
          final realIndex = ((page - 1) * pageSize) + index;
          return User(
            id: realIndex,
            name: 'User #$realIndex',
          );
        },
      ),
      pageSize: pageSize,
    );
  }
}

/// endregion

/// region Generated code

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

/// Used as a contractor for the bloc, events and states classes
/// {@nodoc}
abstract class UserBlocType extends RxBlocTypeBase {
  /// Events of the bloc
  UserBlocEvents get events;

  /// States of the bloc
  UserBlocStates get states;
}

/// [$UserBloc] extended by the [UserBloc]
/// {@nodoc}
abstract class $UserBloc extends RxBlocBase
    implements UserBlocEvents, UserBlocStates, UserBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [loadPage]
  final _$loadPageEvent = PublishSubject<bool>();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final Stream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final Stream<String> _errorsState = _mapToErrorsState();

  /// The state of [paginatedList] implemented in [_mapToPaginatedListState]
  late final Stream<PaginatedList<User>> _paginatedListState =
      _mapToPaginatedListState();

  @override
  void loadPage({bool reset = false}) => _$loadPageEvent.add(reset);

  @override
  Stream<bool> get isLoading => _isLoadingState;

  @override
  Stream<String> get errors => _errorsState;

  @override
  Stream<PaginatedList<User>> get paginatedList => _paginatedListState;

  Stream<bool> _mapToIsLoadingState();

  Stream<String> _mapToErrorsState();

  Stream<PaginatedList<User>> _mapToPaginatedListState();

  @override
  UserBlocEvents get events => this;

  @override
  UserBlocStates get states => this;

  @override
  void dispose() {
    _$loadPageEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}

/// endregion
