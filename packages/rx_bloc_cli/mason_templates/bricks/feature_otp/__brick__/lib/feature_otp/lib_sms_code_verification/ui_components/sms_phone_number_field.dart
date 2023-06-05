import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../bloc/sms_code_bloc.dart';

/// SmsPhoneNumberField  is wrapper that helps users to build a field to present
/// the currently saved phone number and option to update it.It depends on SmsCodeBlocType,
/// so make sure you have that bloc provided in the context above this widget.
/// Use [builder] method to create UI component, such as PrimeTextFieldDialog.
class SmsPhoneNumberField extends StatelessWidget {
  const SmsPhoneNumberField({required this.builder, Key? key})
      : super(key: key);

  final Widget Function(BuildContext context, String? phoneNumber,
      void Function(String newNumber) updatePhoneNumber) builder;

  @override
  Widget build(BuildContext context) => RxBlocBuilder<SmsCodeBlocType, String>(
        state: (bloc) => bloc.states.phoneNumber,
        builder: (context, phoneNumber, bloc) => builder.call(
            context,
            phoneNumber.data,
            (String number) => bloc.events.updatePhoneNumber(number)),
      );
}
