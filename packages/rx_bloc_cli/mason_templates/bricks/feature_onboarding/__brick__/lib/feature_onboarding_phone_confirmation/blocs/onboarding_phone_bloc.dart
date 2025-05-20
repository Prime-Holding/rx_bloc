{{> licence.dart }}

import 'package:go_router/go_router.dart';
import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/app/config/app_constants.dart';
import '../../base/common_services/onboarding_service.dart';
import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/country_code_model.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/models/user_model.dart';
import '../../lib_router/router.dart';
import '../services/phone_number_validator_service.dart';

part 'onboarding_phone_bloc.rxb.g.dart';

/// A contract class containing all events of the OnboardingBloC
abstract class OnboardingPhoneBlocEvents {
  /// Sets the country code for the phone number
  void setCountryCode(CountryCodeModel countryCode);

  /// Sets the phone number
  @RxBlocEvent(type: RxBlocEventType.behaviour, seed: '')
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

  /// Error state of the bloc
  Stream<ErrorModel> get errors;

  /// Determines if the validation errors should be shown
  Stream<bool> get showErrors;
}

/// The [OnboardingPhoneBloc] handles the user's phone number setup
@RxBloc()
class OnboardingPhoneBloc extends $OnboardingPhoneBloc {
  OnboardingPhoneBloc(
    this._isOnboarding,
    this._onboardingService,
    this._numberValidatorService,
    this._router,
  ) {
    phoneSubmitted.connect().addTo(_compositeSubscription);
  }

  /// Indicates if the user is onboarding
  final bool _isOnboarding;

  /// Service used to validate user provided phone number
  final PhoneNumberValidatorService _numberValidatorService;

  /// The onboarding service used to communicate the user phone number
  final OnboardingService _onboardingService;

  /// GoRouter used for navigating between pages
  final GoRouter _router;

  @override
  Stream<bool> _mapToIsLoadingState() => loadingState;

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorState.mapToErrorModel();

  @override
  Stream<bool> _mapToShowErrorsState() => _$submitPhoneNumberEvent
      .switchMap((event) => Rx.combineLatest2(
            countryCode,
            phoneNumber,
            (country, phone) => true,
          ).onErrorReturn(true))
      .share();

  @override
  Stream<CountryCodeModel?> _mapToCountryCodeState() => _$setCountryCodeEvent
      .startWith(CountryCodeModel.withDefault())
      .shareReplay(maxSize: 1);

  @override
  Stream<String> _mapToPhoneNumberState() => Rx.combineLatest2(
          _$setPhoneNumberEvent,
          countryCode.startWith(null),
          (phone, country) => (phone, country))
      .map((args) => _numberValidatorService.validateNumberAndCountryCode(
          args.$1, args.$2))
      .startWith('')
      .shareReplay(maxSize: 1);

  String? _validateAndFormatPhoneNumber(
    Result<CountryCodeModel?> countryCodeResult,
    Result<String> phoneResult,
  ) {
    if (countryCodeResult is ResultSuccess && phoneResult is ResultSuccess) {
      final code =
          (countryCodeResult as ResultSuccess<CountryCodeModel?>).data?.code ??
              '';
      final phone = (phoneResult as ResultSuccess<String>).data;

      return '+$code $phone';
    }

    return null;
  }

  @override
  ConnectableStream<UserModel> _mapToPhoneSubmittedState() =>
      _$submitPhoneNumberEvent
          .throttleTime(kBackpressureDuration)
          .withLatestFrom2(
              countryCode.asResultStream(),
              phoneNumber.asResultStream(),
              (_, country, phone) =>
                  _validateAndFormatPhoneNumber(country, phone))
          .whereNotNull()
          .switchMap((fullPhoneNumber) => _onboardingService
              .submitPhoneNumber(fullPhoneNumber)
              .asResultStream())
          .setResultStateHandler(this)
          .whereSuccess()
          .doOnData((_) {
        if (_isOnboarding) {
          _router.push(const OnboardingPhoneConfirmRoute().routeLocation);
        } else {
          _router.push(const PhoneChangeConfirmRoute().routeLocation);
        }
      }).publish();
}
