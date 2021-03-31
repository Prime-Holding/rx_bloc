import 'package:favorites_advanced_base/core.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:booking_app/base/repositories/paginated_hotels_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';

part 'hotels_extra_details_bloc.rxb.g.dart';
part 'hotels_extra_details_bloc_extensions.dart';

// ignore: one_member_abstracts
abstract class HotelsExtraDetailsEvents {
  void fetchExtraDetails(Hotel hotel, {bool allProps = false});
}

abstract class HotelsExtraDetailsStates {}

@RxBloc()
class HotelsExtraDetailsBloc extends $HotelsExtraDetailsBloc {
  HotelsExtraDetailsBloc(
    CoordinatorBlocType coordinatorBloc,
    PaginatedHotelsRepository repository,
  ) {
    // This event is emitted when a hotel entity becomes visible on the screen.
    _$fetchExtraDetailsEvent
        // Fetch extra details collected in 100 millisecond buckets.
        .fetchExtraDetails(repository, coordinatorBloc)
        // Bind the result (List<Hotels>) to the local state
        .bind(_lastFetchedHotels)
        // Always make sure your subscriptions are disposed of!
        .disposedBy(_compositeSubscription);
  }

  final _lastFetchedHotels = BehaviorSubject<List<Hotel>>.seeded([]);

  @override
  void dispose() {
    _lastFetchedHotels.close();
    super.dispose();
  }
}
