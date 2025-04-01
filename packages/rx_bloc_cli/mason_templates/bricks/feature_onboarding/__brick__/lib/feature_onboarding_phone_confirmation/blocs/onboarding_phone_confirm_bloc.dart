{{> licence.dart }}

import 'package:go_router/go_router.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_blocs/coordinator_bloc.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/models/user_model.dart';
import '../../lib_permissions/services/permissions_service.dart';
import '../../lib_router/router.dart';

part 'onboarding_phone_confirm_bloc.rxb.g.dart';

abstract class OnboardingPhoneConfirmBlocEvents {
  /// Sets the confirmation result
  void setConfirmationResult(dynamic result);
}

abstract class OnboardingPhoneConfirmBlocStates {
  /// The error state of the bloc
  Stream<ErrorModel> get errors;

  /// The routing state for navigating to next page
  ConnectableStream<void> get onRouting;
}

@RxBloc()
class OnboardingPhoneConfirmBloc extends $OnboardingPhoneConfirmBloc {
  OnboardingPhoneConfirmBloc(
    this._isOnboarding,
    this._router,
    this._permissionsService,
    this._coordinatorBloc,
  ) {
    onRouting.connect().addTo(_compositeSubscription);
  }

  /// Indicates if the user is onboarding
  final bool _isOnboarding;

  /// GoRouter instance used for navigation
  final GoRouter _router;

  /// Service used to handle permissions
  final PermissionsService _permissionsService;

  /// Coordinator bloc used to communicate with other blocs
  final CoordinatorBlocType _coordinatorBloc;

  @override
  ConnectableStream<void> _mapToOnRoutingState() => _$setConfirmationResultEvent
      .switchMap((result) => _onResultChanged(result).asResultStream())
      .whereSuccess()
      .publish();

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  Future<void> _onResultChanged(dynamic result) async {
    final updatedUser = result as UserModel?;
    if (updatedUser == null || !updatedUser.confirmedCredentials.phone) return;

    await _permissionsService.getPermissions(force: true);

    if (!_isOnboarding) {
      _coordinatorBloc.events.updatePhoneNumber();
      return _router.go(const ProfileRoute().location);
    }

    return _router.go(const DashboardRoute().routeLocation);
  }
}
