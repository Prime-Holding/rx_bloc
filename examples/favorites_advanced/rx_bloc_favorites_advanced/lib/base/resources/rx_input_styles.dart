import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/rx_form.dart';

class RxInputStyles {
  static const textFieldDecorationData = RxInputDecorationData(
    labelStyle: TextStyle(
      color: Color(0xff333333),
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
      fontStyle: FontStyle.normal,
      fontSize: 14,
    ),
    labelStyleError: TextStyle(
      color: Color(0xffff6b2a),
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
      fontStyle: FontStyle.normal,
      fontSize: 14,
    ),
    iconVisibility: Icon(Icons.visibility),
    iconVisibilityOff: Icon(Icons.visibility_off),
  );
}