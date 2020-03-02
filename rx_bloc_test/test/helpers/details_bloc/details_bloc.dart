import 'package:rx_bloc/annotation/rx_bloc_annotations.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'details_bloc.g.dart';

class DetailsRepository {
  Future<String> fetch() {
    return Future.delayed(
        Duration(milliseconds: 60), () => Future.value('Success'));
  }
}

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
  Stream<String> mapToDetailsState() => $fetchEvent
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
