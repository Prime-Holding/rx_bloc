{{> licence.dart }}

import 'package:rx_bloc/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:widget_toolkit_pin/widget_toolkit_pin.dart';

import '../models/pin_code_data.dart';
import '../services/app_pin_code_service.dart';

part 'pin_bloc.rxb.g.dart';

/// A contract class containing all events of the PinCodeBloC.
abstract class PinBlocEvents {
  void setPinCodeData(PinCodeData data);
}

/// A contract class containing all states of the PinCodeBloC.
abstract class PinBlocStates {
  ConnectableStream<PinCodeData> get pinCodeData;
}

@RxBloc()
class PinBloc extends $PinBloc {
  PinBloc({required this.service}) {
    pinCodeData.connect().addTo(_compositeSubscription);
  }

  final PinCodeService service;

  @override
  ConnectableStream<PinCodeData> _mapToPinCodeDataState() =>
      _$setPinCodeDataEvent
          .switchMap((value) => (service as AppPinCodeService)
              .setIsPinCreated(value.isPinCodeCreated)
              .asResultStream())
          .setResultStateHandler(this)
          .whereSuccess()
          .publish();
}
