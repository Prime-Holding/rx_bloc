import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'details_bloc.rxb.g.dart';

class DetailsRepository {
  Future<String> fetch() async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    return Future.value('Success');
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
  DetailsBloc(this._detailsRepository);

  final DetailsRepository _detailsRepository;

  @override
  Stream<String> _mapToDetailsState() => _$fetchEvent
      .startWith(null)
      .flatMap((_) => _detailsRepository.fetch().asResultStream())
      .setResultStateHandler(this)
      .whereSuccess();

  @override
  Stream<String> get errors => errorState.map((result) => result.toString());

  @override
  Stream<bool> get isLoading => loadingState;
}
