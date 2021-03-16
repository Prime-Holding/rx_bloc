import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/models.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RxBlocList Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RxBlocProvider<UserBlocType>(
        create: (context) => UserBloc(repository: UserRepository()),
        child: MyHomePage(),
      ),
    );
  }
}

/// region Home page

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: RxPaginatedBuilder<UserBlocType, User>.withRefreshIndicator(
            builder: (context, snapshot, bloc) => _buildPaginatedList(snapshot),
            state: (bloc) => bloc.states.paginatedList,
            onBottomScrolled: (bloc) => bloc.events.loadPage(),
            onRefresh: (bloc) async {
              bloc.events.loadPage(reset: true);
            },
          ),
        ),
      );

  Widget _buildPaginatedList(AsyncSnapshot<PaginatedList<User>> snapshot) {
    if (!snapshot.hasData ||
        (snapshot.hasData && snapshot.data!.isInitialLoading)) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final list = snapshot.data!;

    return ListView.builder(
      itemBuilder: (context, index) => itemBuilder(list, index),
      itemCount: list.itemCount,
    );
  }

  Widget itemBuilder(PaginatedList<User> list, int index) {
    if (list.length == index) {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 12),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Card(
      child: ListTile(
        title: Text(list[index].name),
      ),
    );
  }
}

/// endregion

/// region Models and repositories

class UserRepository {
  Future<PaginatedList<User>> fetchPage(int page, int pageSize) async {
    await Future.delayed(Duration(seconds: 2));

    if (page > 10)
      return PaginatedList(
        list: [],
        pageSize: pageSize,
      );

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

class User {
  User({
    required this.id,
    this.name = '',
  });

  final int id;
  final String name;
}

/// endregion

/// region User Bloc

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

  Stream<PaginatedList<User>> get paginatedList;
}

@RxBloc()
class UserBloc extends $UserBloc {
  final _paginatedList = BehaviorSubject<PaginatedList<User>>.seeded(
    PaginatedList<User>(
      list: [],
      pageSize: 50,
    ),
  );

  UserBloc({required UserRepository repository}) {
    _$loadPageEvent
        .startWith(true)
        .switchMap(
          (reset) {
            if (reset) _paginatedList.value!.length = 0;

            return repository
                .fetchPage(
                  _paginatedList.value!.pageNumber + 1,
                  _paginatedList.value!.pageSize,
                )
                .asResultStream();
          },
        )
        .setResultStateHandler(this)
        .mergeWithPaginatedList(_paginatedList)
        .bind(_paginatedList)
        .disposedBy(_compositeSubscription);
  }

  @override
  Stream<PaginatedList<User>> _mapToPaginatedListState() => _paginatedList;

  @override
  Stream<String> _mapToErrorsState() =>
      errorState.map((event) => event.toString());

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  void dispose() {
    _paginatedList.close();
    super.dispose();
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
  UserBlocEvents get events;
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
