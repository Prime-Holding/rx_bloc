import 'dart:async';

import 'package:favorites_advanced_base/core.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_list/rx_bloc_list.dart';

import 'package:rxdart/rxdart.dart';

import '../../../base/common_blocs/coordinator_bloc.dart';
import '../../../base/repositories/paginated_puppies_repository.dart';

part 'puppy_list_bloc.rxb.g.dart';
part 'puppy_list_bloc_extensions.dart';
part 'puppy_list_bloc_models.dart';

abstract class PuppyListEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
  void filter({required String query});

  @RxBlocEvent(
    type: RxBlocEventType.behaviour,
    seed: _ReloadEventArgs(reset: true, fullReset: false),
  )
  void reload({required bool reset, bool fullReset = false});
}

abstract class PuppyListStates {
  @RxBlocIgnoreState()
  Stream<PaginatedList<Puppy>> get searchedPuppies;

  /// Returns when the data refreshing has completed
  @RxBlocIgnoreState()
  Future<void> get refreshDone;
}

@RxBloc()
class PuppyListBloc extends $PuppyListBloc {
  PuppyListBloc(
    PaginatedPuppiesRepository repository,
    CoordinatorBlocType coordinatorBloc,
  ) {
    Rx.merge([
      _$filterEvent.mapToPayload(),
      _$reloadEvent.mapToPayload(_$filterEvent),
    ])
        .startWith(_ReloadData(reset: true, query: ''))
        .fetchPuppies(repository, _puppies)
        .setResultStateHandler(this)
        .mergeWithPaginatedList(_puppies)
        .bind(_puppies)
        .disposedBy(_compositeSubscription);

    coordinatorBloc.states.onPuppiesUpdated
        .updatePuppies(_puppies)
        .disposedBy(_compositeSubscription);
  }

  @override
  Future<void> get refreshDone async => _puppies.waitToLoad();

  // MARK: - Subjects
  final _puppies = BehaviorSubject<PaginatedList<Puppy>>.seeded(
    PaginatedList(
      pageSize: 10,
      list: [],
    ),
  );

  @override
  Stream<PaginatedList<Puppy>> get searchedPuppies => _puppies;

  @override
  void dispose() {
    _puppies.close();
    super.dispose();
  }
}
