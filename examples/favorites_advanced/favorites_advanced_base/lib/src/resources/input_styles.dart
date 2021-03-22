import 'package:flutter/material.dart';

class InputStyles {

  static const textFieldDecoration = InputDecoration(
    filled: true,
    fillColor: Color(0xffebecf2),
    errorStyle: TextStyle(
      color: Color(0xffff6b2a),
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
      fontStyle: FontStyle.normal,
      fontSize: 12,
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xffdfdfdf)),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xff04c9eb)),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xffff6b2a)),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xffff6b2a)),
    ),
  );
}
