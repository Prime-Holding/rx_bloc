import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:favorites_advanced_base/models.dart';
part 'puppies_extra_details_event.dart';

part 'puppies_extra_details_state.dart';

// part 'puppies_extra_details_bloc_extensions.dart';

class PuppiesExtraDetailsBloc
    extends Bloc<PuppiesExtraDetailsEvent, PuppiesExtraDetailsState> {
  PuppiesExtraDetailsBloc(this.repository)
      : super(PuppiesExtraDetailsState());

  static final List<Puppy> _initialPuppiesWithDetails = [];
  List<Puppy> puppiesWithDetails = [];
  PuppiesRepository repository;

  // StreamSubscription puppyListStreamSubscription;

  @override
  Stream<PuppiesExtraDetailsState> mapEventToState(
    PuppiesExtraDetailsEvent event,
  ) async* {
    if (event is FetchPuppiesExtraDetailsEvent) {
      // puppiesWithDetails = puppiesWithDetails //.fetchExtraDetails(repository);
      // .whereNoExtraDetails()
      //     .mergeWith(repository.fetchFullEntities(ids))
      // This event is emitted when a puppy entity becomes
      // visible on the screen.
      yield PuppiesExtraDetailsState();
    }
  }

// @override
// close(){
//   puppyListStreamSubsciption.cancel();
// }
}

// extension _FetchExtraDetails on List<Puppy>{
//   List<Puppy> fetchExtraDetails(PuppiesRepository repository) =>
      
// }
