import 'package:rx_bloc/annotation/rx_bloc_annotations.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../repository/details_repository.dart';

part 'details_bloc.rxb.g.dart';

abstract class DetailsBlocEvents {
  void fetch();
}

abstract class DetailsBlocStates {
  Stream<Result<String>> get details;

  @RxBlocIgnoreState()
  Stream<bool> get isLoading;

  @RxBlocIgnoreState()
  Stream<String> get errors;
}

@RxBloc()
class DetailsBloc extends $DetailsBloc {
  DetailsRepository _detailsRepository;

  DetailsBloc(this._detailsRepository);

  @override
  Stream<Result<String>> _mapToDetailsState() => _$fetchEvent
      .startWith(null)
      .flatMap((_) => _detailsRepository.fetch().asResultStream())
      .setResultStateHandler(this);

  @override
  Stream<String> get errors =>
      errorState.map((exception) => exception.toString());

  @override
  Stream<bool> get isLoading => loadingState;
}
