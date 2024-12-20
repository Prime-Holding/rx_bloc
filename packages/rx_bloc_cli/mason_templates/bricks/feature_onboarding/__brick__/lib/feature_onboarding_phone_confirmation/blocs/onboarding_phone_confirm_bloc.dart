import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/common_services/onboarding_service.dart';
import '../../base/models/user_model.dart';
import '../../lib_permissions/services/permissions_service.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';

part 'onboarding_phone_confirm_bloc.rxb.g.dart';

abstract class OnboardingPhoneConfirmBlocEvents {
  /// Sets the confirmation result
  void setConfirmationResult(dynamic result);
}

abstract class OnboardingPhoneConfirmBlocStates {
  /// The routing state for navigating to next page
  ConnectableStream<void> get onRouting;
}

@RxBloc()
class OnboardingPhoneConfirmBloc extends $OnboardingPhoneConfirmBloc {
  OnboardingPhoneConfirmBloc(
    this._routerBloc,
    this._onboardingService,
    this._permissionsService,
  ) {
    onRouting.connect().addTo(_compositeSubscription);
  }

  final OnboardingService _onboardingService;
  final RouterBlocType _routerBloc;
  final PermissionsService _permissionsService;

  @override
  ConnectableStream<void> _mapToOnRoutingState() =>
      _$setConfirmationResultEvent.map(_onResultChanged).publish();

  Future<void> _onResultChanged(dynamic result) async {
    final updatedUser = result as UserModel?;
    if (updatedUser == null || !updatedUser.confirmedCredentials.phone) return;

    await _onboardingService.setIsProfileTemporary(false);
    await _permissionsService.getPermissions(force: true);
    return _routerBloc.events.go(const DashboardRoute());
  }
}
