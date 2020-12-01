import 'package:favorites_advanced_base/core.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../base/common_blocs/coordinator_bloc.dart';

part 'puppy_manage_bloc.rxb.g.dart';
part 'puppy_manage_bloc_extensions.dart';

// ignore: one_member_abstracts
abstract class PuppyManageEvents {
  void markAsFavorite({Puppy puppy, bool isFavorite});
}

abstract class PuppyManageStates {
  @RxBlocIgnoreState()
  Stream<Puppy> get puppy;

  @RxBlocIgnoreState()
  Stream<String> get error;
}

@RxBloc()
class PuppyManageBloc extends $PuppyManageBloc {
  PuppyManageBloc(
    PuppiesRepository puppiesRepository,
    CoordinatorBlocType coordinatorBloc,
  ) {
    _$markAsFavoriteEvent
        .markPuppyAsFavorite(puppiesRepository, this, coordinatorBloc)
        .bind(_lastUpdatedPuppy)
        .disposedBy(_compositeSubscription);
  }
  final _lastUpdatedPuppy = BehaviorSubject<Puppy>();
  final _compositeSubscription = CompositeSubscription();
  final _favoritePuppyError = PublishSubject<Exception>();

  @override
  Stream<Puppy> get puppy => _lastUpdatedPuppy;

  @override
  Stream<String> get error => Rx.merge([errorState, _favoritePuppyError])
      .map((exc) => exc.toString())
      .share();

  @override
  void dispose() {
    _lastUpdatedPuppy.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
