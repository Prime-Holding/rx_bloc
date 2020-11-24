import 'package:bloc_battle_base/core.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_sample/base/common_blocs/coordinator_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'puppies_extra_details_bloc.rxb.g.dart';
part 'puppies_extra_details_bloc_extensions.dart';

// ignore: one_member_abstracts
abstract class PuppiesExtraDetailsEvents {
  void fetchExtraDetails(Puppy puppy);
}

abstract class PuppiesExtraDetailsStates {}

@RxBloc()
class PuppiesExtraDetailsBloc extends $PuppiesExtraDetailsBloc {
  PuppiesExtraDetailsBloc(
      CoordinatorBlocType coordinatorBloc, PuppiesRepository repository) {
    _$fetchExtraDetailsEvent
        .fetchExtraDetails(repository, coordinatorBloc)
        .bind(_lastFetchedPuppies)
        .disposedBy(_compositeSubscription);
  }

  final _lastFetchedPuppies = BehaviorSubject<List<Puppy>>.seeded([]);
  final _compositeSubscription = CompositeSubscription();

  @override
  void dispose() {
    _lastFetchedPuppies.close();
    _compositeSubscription.dispose();
    super.dispose();
  }
}
