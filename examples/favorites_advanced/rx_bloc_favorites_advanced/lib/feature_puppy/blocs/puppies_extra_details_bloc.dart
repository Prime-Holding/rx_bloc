import 'package:favorites_advanced_base/core.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/repositories/paginated_puppies_repository.dart';

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
    CoordinatorBlocType coordinatorBloc,
    PaginatedPuppiesRepository repository,
  ) {
    // This event is emitted when a puppy entity becomes visible on the screen.
    _$fetchExtraDetailsEvent
        // Fetch extra details collected in 100 millisecond buckets.
        .fetchExtraDetails(repository, coordinatorBloc)
        // Bind the result (List<Puppies>) to the local state
        .bind(_lastFetchedPuppies)
        // Always make sure your subscriptions are disposed of!
        .disposedBy(_compositeSubscription);
  }

  final _lastFetchedPuppies = BehaviorSubject<List<Puppy>>.seeded([]);

  @override
  void dispose() {
    _lastFetchedPuppies.close();
    super.dispose();
  }
}
