import 'package:flutter/material.dart';

import '../../../core.dart';

class DesignSystem {
  DesignSystem({required this.colors});

  final DesignSystemColor colors;

  ThemeData get theme => HotelAppTheme.buildTheme(colors);
}
