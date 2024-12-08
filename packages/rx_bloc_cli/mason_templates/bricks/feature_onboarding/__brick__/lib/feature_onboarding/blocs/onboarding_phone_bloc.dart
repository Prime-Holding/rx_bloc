import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/extensions/error_model_extensions.dart';
import '../../base/models/errors/error_model.dart';
import '../../base/models/user_model.dart';
import '../models/onboarding_phone_errors.dart';
import '../services/user_service.dart';

part 'onboarding_phone_bloc.rxb.g.dart';
part 'onboarding_phone_bloc_extensions.dart';

/// A contract class containing all events of the OnboardingBloC
abstract class OnboardingPhoneBlocEvents {
  /// Sets the country code for the phone number
  void setCountryCode(String countryCode);

  /// Sets the phone number
  void setPhoneNumber(String phoneNumber);

  /// Checks if the phone number is valid
  void submitPhoneNumber();
}

/// A contract class containing all states of the OnboardingBloC.
abstract class OnboardingPhoneBlocStates {
  /// The loading state of the bloc
  Stream<bool> get isLoading;

  /// The user model
  Stream<UserModel> get user;

  /// The country code used for the phone number
  Stream<String?> get countryCode;

  /// The phone number
  Stream<String> get phoneNumber;

  /// The state of the submit phone number button
  Stream<bool> get submitPhoneNumberEnabled;

  /// Error state of the bloc
  Stream<ErrorModel> get errors;

  /// Error state as a result of a validation
  @RxBlocIgnoreState()
  Stream<ErrorModel?> get validationErrors;
}

/// The [OnboardingPhoneBloc] handles the user's phone number setup
@RxBloc()
class OnboardingPhoneBloc extends $OnboardingPhoneBloc {
  OnboardingPhoneBloc(this._userService) {
    errorWithTagState
        .map((errorWithTag) => errorWithTag.tag == tagValidation
            ? errorWithTag.exception.asErrorModel()
            : null)
        .bind(_validationErrorSubject);
  }

  /// The user service used to communicate the user phone number
  final UserService _userService;

  /// Tag used to denote the submit phone number event
  static const tagSubmitPhoneNumber = 'SubmitPhoneNumber';

  /// Tag used to denote validation results
  static const tagValidation = 'Validation';

  /// Subject to handle validation errors
  final _validationErrorSubject = BehaviorSubject<ErrorModel?>();

  @override
  Stream<ErrorModel> _mapToErrorsState() => errorWithTagState
      .where((errorWithTag) => errorWithTag.tag == tagSubmitPhoneNumber)
      .map((error) => error.exception)
      .mapToErrorModel();

  @override
  Stream<ErrorModel?> get validationErrors => _validationErrorSubject;

  @override
  Stream<bool> _mapToIsLoadingState() => loadingWithTagState
      .where((loadingWithTag) => loadingWithTag.tag == tagSubmitPhoneNumber)
      .map((loadingWithTag) => loadingWithTag.loading)
      .distinct();

  @override
  Stream<String?> _mapToCountryCodeState() => _$setCountryCodeEvent;

  @override
  Stream<String> _mapToPhoneNumberState() => _$setPhoneNumberEvent
      .map((phoneNumber) => phoneNumber.replaceAll(' ', ''))
      .startWith('')
      .distinct();

  @override
  Stream<UserModel> _mapToUserState() => _$submitPhoneNumberEvent
      .debounceTime(const Duration(milliseconds: 500))
      .withLatestFrom2(
          countryCode,
          phoneNumber,
          (_, String? countryCode, String phoneNumber) =>
              '+$countryCode$phoneNumber')
      .switchMap((fullPhoneNumber) => _userService
          .submitPhoneNumber(fullPhoneNumber)
          .asResultStream(tag: tagSubmitPhoneNumber))
      .setResultStateHandler(this)
      .whereSuccess()
      .asBroadcastStream();

  @override
  Stream<bool> _mapToSubmitPhoneNumberEnabledState() => Rx.merge<bool>([
        Rx.combineLatest2(
          countryCode.startWith(null),
          phoneNumber.skip(1), // skip the initial empty value
          (String? countryCode, String phoneNumber) =>
              _validatePhoneNumber(countryCode, phoneNumber),
        )
            .asResultStream(tag: tagValidation)
            .setResultStateHandler(this)
            .whereSuccess()
            // On successful validation, clear the validation error
            .doOnData((_) => _validationErrorSubject.add(null)),
        validationErrors.map((error) => error == null),
      ]).startWith(false);

  @override
  void dispose() {
    _validationErrorSubject.close();
    super.dispose();
  }
}
