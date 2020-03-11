import 'package:example/repository/details_repository.dart';
import 'package:rx_bloc/annotation/rx_bloc_annotations.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'details_bloc.g.dart';

abstract class DetailsBlocEvents {
  void fetch();
}

abstract class DetailsBlocStates {
  Stream<String> get details;

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
  Stream<String> _mapToDetailsState() => _$fetchEvent
      .startWith(null)
      .flatMap((_) => _detailsRepository.fetch().asResultStream())
      .registerRequest(this)
      .whereSuccess();

  @override
  Stream<String> get errors =>
      requestsExceptions.map((exception) => exception.toString());

  @override
  Stream<bool> get isLoading => requestsLoadingState;
}
