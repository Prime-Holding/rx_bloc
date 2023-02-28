{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_services/deep_link_service.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/deep_link_model.dart';
import '../../base/models/errors/error_model.dart';

part 'deep_link_details_bloc.rxb.g.dart';

/// A contract class containing all events of the DeepLinkDetailsBloC.
abstract class DeepLinkDetailsBlocEvents {
  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void fetchDeepLinkDetailsById(String deepLinkId);

  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void showDeepLinkDetails(DeepLinkModel item);
}

/// A contract class containing all states of the DeepLinkDetailsBloC.
abstract class DeepLinkDetailsBlocStates {
  /// The loading state
  Stream<bool> get isLoading;

  /// The error state
  Stream<ErrorModel> get errors;

  Stream<Result<DeepLinkModel>> get deepLink;
}

@RxBloc()
class DeepLinkDetailsBloc extends $DeepLinkDetailsBloc {
  DeepLinkDetailsBloc(
    this._deepLinkService, {
    required String deepLinkId,
    DeepLinkModel? deepLink,
  }) {
    initDeepLinkDetailsData(
      deepLinkId: deepLinkId,
      deepLink: deepLink,
    );
  }

  final DeepLinkService _deepLinkService;

  void initDeepLinkDetailsData(
      {required String deepLinkId, DeepLinkModel? deepLink}) {
    if (deepLink != null) {
      showDeepLinkDetails(deepLink);
    } else {
      fetchDeepLinkDetailsById(deepLinkId);
    }
  }

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<Result<DeepLinkModel>> _mapToDeepLinkState() => Rx.merge([
        _$fetchDeepLinkDetailsByIdEvent.switchMap((linkId) =>
            _deepLinkService.fetchDeepLinkById(id: linkId).asResultStream()),
        _$showDeepLinkDetailsEvent.mapToResult((link) => link),
      ]).setResultStateHandler(this).shareReplay(maxSize: 1);
}
