import 'package:favorites_advanced_base/core.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rx_bloc_favorites_advanced/base/common_blocs/coordinator_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'puppy_edit_bloc.rxb.g.dart';
part 'puppy_edit_bloc_extensions.dart';

// ignore: one_member_abstracts
abstract class PuppyEditBlocEvents {
  void updatePuppy(Puppy newPuppy, Puppy oldPuppy);
}

abstract class PuppyEditBlocStates {
  @RxBlocIgnoreState()
  Stream<bool> get successfulUpdate;

  @RxBlocIgnoreState()
  Stream<bool> get processingUpdate;

  @RxBlocIgnoreState()
  Stream<String> get updateError;

}

@RxBloc()
class PuppyEditBloc extends $PuppyEditBloc {
  PuppyEditBloc(
    PuppiesRepository repository,
    CoordinatorBlocType coordinatorBloc,
  )   : _puppiesRepository = repository,
        _coordinatorBlocType = coordinatorBloc;

  final PuppiesRepository _puppiesRepository;
  final CoordinatorBlocType _coordinatorBlocType;

  @override
  Stream<bool> get successfulUpdate => editPuppy().doOnData((data) {
        _coordinatorBlocType.events.puppyUpdated(data);
      }).map((value) => value != null);

  @override
  Stream<bool> get processingUpdate => loadingState;

  @override
  Stream<String> get updateError => errorState.mapToString();
}
