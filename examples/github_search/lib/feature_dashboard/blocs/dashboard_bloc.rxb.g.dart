// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: RxBlocGeneratorForAnnotation
// **************************************************************************

part of 'dashboard_bloc.dart';

/// Used as a contractor for the bloc, events and states classes
/// @nodoc
abstract class DashboardBlocType extends RxBlocTypeBase {
  DashboardBlocEvents get events;
  DashboardBlocStates get states;
}

/// [$DashboardBloc] extended by the [DashboardBloc]
/// @nodoc
abstract class $DashboardBloc extends RxBlocBase
    implements DashboardBlocEvents, DashboardBlocStates, DashboardBlocType {
  final _compositeSubscription = CompositeSubscription();

  /// Тhe [Subject] where events sink to by calling [fetchSuggestionList]
  final _$fetchSuggestionListEvent = PublishSubject<void>();

  /// Тhe [Subject] where events sink to by calling [searchByQuery]
  final _$searchByQueryEvent = BehaviorSubject<String>.seeded('Flutter');

  /// Тhe [Subject] where events sink to by calling [loadPage]
  final _$loadPageEvent = PublishSubject<void>();

  /// The state of [isLoading] implemented in [_mapToIsLoadingState]
  late final ConnectableStream<bool> _isLoadingState = _mapToIsLoadingState();

  /// The state of [errors] implemented in [_mapToErrorsState]
  late final ConnectableStream<ErrorModel> _errorsState = _mapToErrorsState();

  /// The state of [searchList] implemented in [_mapToSearchListState]
  late final Stream<PaginatedList<GithubRepoModel>> _searchListState =
      _mapToSearchListState();

  /// The state of [suggestionList] implemented in [_mapToSuggestionListState]
  late final ConnectableStream<List<GithubRepoModel>> _suggestionListState =
      _mapToSuggestionListState();

  @override
  void fetchSuggestionList() => _$fetchSuggestionListEvent.add(null);

  @override
  void searchByQuery(String query) => _$searchByQueryEvent.add(query);

  @override
  void loadPage() => _$loadPageEvent.add(null);

  @override
  ConnectableStream<bool> get isLoading => _isLoadingState;

  @override
  ConnectableStream<ErrorModel> get errors => _errorsState;

  @override
  Stream<PaginatedList<GithubRepoModel>> get searchList => _searchListState;

  @override
  ConnectableStream<List<GithubRepoModel>> get suggestionList =>
      _suggestionListState;

  ConnectableStream<bool> _mapToIsLoadingState();

  ConnectableStream<ErrorModel> _mapToErrorsState();

  Stream<PaginatedList<GithubRepoModel>> _mapToSearchListState();

  ConnectableStream<List<GithubRepoModel>> _mapToSuggestionListState();

  @override
  DashboardBlocEvents get events => this;

  @override
  DashboardBlocStates get states => this;

  @override
  void dispose() {
    _$fetchSuggestionListEvent.close();
    _$searchByQueryEvent.close();
    _$loadPageEvent.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
