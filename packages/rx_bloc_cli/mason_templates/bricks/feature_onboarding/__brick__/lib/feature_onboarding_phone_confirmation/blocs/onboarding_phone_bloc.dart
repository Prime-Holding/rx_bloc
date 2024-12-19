import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/app/config/app_constants.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/country_code_model.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/models/user_model.dart';
import '../../base/services/users_service.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../../lib_router/router.dart';
import '../services/phone_number_validator_service.dart';

part 'onboarding_phone_bloc.rxb.g.dart';

/// A contract class containing all events of the OnboardingBloC
abstract class OnboardingPhoneBlocEvents {
  /// Sets the country code for the phone number
  void setCountryCode(CountryCodeModel countryCode);

  /// Sets the phone number
  void setPhoneNumber(String phoneNumber);

  /// Initiates the submission of the phone number
  void submitPhoneNumber();
}

/// A contract class containing all states of the OnboardingBloC.
abstract class OnboardingPhoneBlocStates {
  /// The loading state of the submit button
  Stream<bool> get isLoading;

  /// State indicating if the phone number has been submitted successfully
  ConnectableStream<UserModel> get phoneSubmitted;

  /// The country code used for the phone number
  Stream<CountryCodeModel?> get countryCode;

  /// The phone number
  Stream<String> get phoneNumber;

  /// The state of the submit phone number button
  Stream<bool> get submitPhoneNumberEnabled;

  /// Error state of the bloc
  Stream<ErrorModel> get errors;

  /// Determines if the validation errors should be shown
  Stream<bool> get showErrors;
}

/// The [OnboardingPhoneBloc] handles the user's phone number setup
@RxBloc()
class OnboardingPhoneBloc extends $OnboardingPhoneBloc {
  OnboardingPhoneBloc(
    this._usersService,
    this._numberValidatorService,
    this._navigationBloc,
  ) {
    phoneSubmitted.connect().addTo(_compositeSubscription);
  }

  /// Service used to validate user provided phone number
  final PhoneNumberValidatorService _numberValidatorService;

  /// The user service used to communicate the user phone number
  final UsersService _usersService;

  /// The navigation bloc used to navigate the user
  final RouterBlocType _navigationBloc;

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToShowErrorsState() =>
      Rx.combineLatest2(countryCode, phoneNumber, (country, phone) => false)
          .onErrorReturn(true)
          .share();

  @override
  Stream<bool> _mapToSubmitPhoneNumberEnabledState() =>
      showErrors.map((errors) => !errors).skip(1).startWith(false);

  @override
  Stream<CountryCodeModel?> _mapToCountryCodeState() => _$setCountryCodeEvent;

  @override
  Stream<String> _mapToPhoneNumberState() => Rx.combineLatest2(
          _$setPhoneNumberEvent,
          countryCode.startWith(null),
          (phone, country) => (phone, country))
      .map((args) => _numberValidatorService.validateNumberAndCountryCode(
          args.$1, args.$2))
      .startWith('')
      .asBroadcastStream();

  @override
  ConnectableStream<UserModel> _mapToPhoneSubmittedState() =>
      _$submitPhoneNumberEvent
          .debounceTime(actionDebounceDuration)
          .withLatestFrom2(countryCode, phoneNumber,
              (_, country, phone) => '+${country?.code ?? ''} $phone')
          .switchMap((fullPhoneNumber) =>
              _usersService.submitPhoneNumber(fullPhoneNumber).asResultStream())
          .setResultStateHandler(this)
          .whereSuccess()
          .doOnData((_) {
        _navigationBloc.events.pushReplace(const OnboardingPhoneConfirmRoute());
      }).publish();
}
