{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:widget_toolkit_biometrics/widget_toolkit_biometrics.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';
import '../services/app_pin_code_service.dart';
import '../services/profile_local_data_source.dart';

part 'pin_bloc.rxb.g.dart';

/// A contract class containing all events of the PinCodeBloC.
abstract class PinBlocEvents {
  /// Event called with true when a pin is created, after the verification
  /// is successful. It is called with false when [isPinCreated] state is false
  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void setIsPinCreated(bool? isPinCreated);

  /// Event for the verification pin entered, before updating with a new pin
  @RxBlocEvent(type: RxBlocEventType.behaviour)
  void setIsVerificationPinCorrect({bool? isVerificationPinCorrect});

  void setIsAuthenticatedWithBiometrics({bool? isAuthenticatedWithBiometrics});

  void deleteSavedData();
}

/// A contract class containing all states of the PinCodeBloC.
abstract class PinBlocStates {
  ConnectableStream<bool> get isPinCreated;

  ConnectableStream<bool> get isVerificationPinCorrect;

  ConnectableStream<bool> get isAuthenticatedWithBiometrics;

  ConnectableStream<void> get deletedData;
}

@RxBloc()
class PinBloc extends $PinBloc {
  PinBloc({required this.service, required this.biometrics}) {
    isVerificationPinCorrect.connect().addTo(_compositeSubscription);
    isAuthenticatedWithBiometrics.connect().addTo(_compositeSubscription);
    isPinCreated.connect().addTo(_compositeSubscription);
    deletedData.connect().addTo(_compositeSubscription);
  }

  final PinCodeService service;
  final BiometricsLocalDataSource biometrics;

  @override
  ConnectableStream<bool> _mapToIsAuthenticatedWithBiometricsState() =>
      _$setIsAuthenticatedWithBiometricsEvent
          .startWith(null)
          .switchMap((value) => (biometrics as ProfileLocalDataSource)
              .isAuthenticatedWithBiometrics(value)
              .asResultStream())
          .setResultStateHandler(this)
          .whereSuccess()
          .publish();

  @override
  ConnectableStream<bool> _mapToIsVerificationPinCorrectState() =>
      _$setIsVerificationPinCorrectEvent
          .switchMap((value) => (service as AppPinCodeService)
              .checkIsVerificationPinCorrect(value)
              .asResultStream())
          .setResultStateHandler(this)
          .whereSuccess()
          .shareReplay(maxSize: 1)
          .publish();

  @override
  ConnectableStream<bool> _mapToIsPinCreatedState() => _$setIsPinCreatedEvent
      .startWith(null)
      .switchMap((value) => (service as AppPinCodeService)
          .setIsPinCreated(value)
          .asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .shareReplay(maxSize: 1)
      .publish();

  @override
  ConnectableStream<void> _mapToDeletedDataState() => _$deleteSavedDataEvent
      .switchMap((_) =>
          (service as AppPinCodeService).deleteSavedData().asResultStream())
      .setResultStateHandler(this)
      .whereSuccess()
      .publish();
}
