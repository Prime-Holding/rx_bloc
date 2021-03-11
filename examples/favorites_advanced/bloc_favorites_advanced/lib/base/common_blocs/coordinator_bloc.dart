// import 'dart:async';
//
// import 'package:favorites_advanced_base/models.dart';
// import 'package:rx_bloc/rx_bloc.dart';
// import 'package:rxdart/rxdart.dart';
//
// part 'coordinator_bloc.rxb.g.dart';
//
// // ignore: one_member_abstracts
// abstract class CoordinatorEvents {
//   void puppyUpdated(Puppy puppy);
//
//   void puppiesWithExtraDetailsFetched(List<Puppy> puppies);
// }
//
// abstract class CoordinatorStates {
//   @RxBlocIgnoreState()
//   Stream<Puppy> get onPuppyUpdated;
//
//   @RxBlocIgnoreState()
//   Stream<List<Puppy>> get onFetchedPuppiesWithExtraDetails;
//
//   Stream<List<Puppy>> get onPuppiesUpdated;
// }
//
// /// The coordinator bloc manages the communication between blocs.
// ///
// /// The goals is to keep all blocs decoupled from each other
// /// as the entire communication flow goes through this bloc.
// /// This way we ensure that we don't introduce a dependency hell.
// @RxBloc()
// class CoordinatorBloc extends $CoordinatorBloc {
//   @override
//   Stream<Puppy> get onPuppyUpdated => _$puppyUpdatedEvent;
//
//   @override
//   Stream<List<Puppy>> get onFetchedPuppiesWithExtraDetails =>
//       _$puppiesWithExtraDetailsFetchedEvent;
//
//   @override
//   Stream<List<Puppy>> _mapToOnPuppiesUpdatedState() => Rx.merge([
//         states.onPuppyUpdated.map((puppy) => [puppy]),
//         states.onFetchedPuppiesWithExtraDetails
//       ]).share();
// }
