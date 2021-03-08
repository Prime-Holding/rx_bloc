import 'package:flutter/material.dart';
import 'package:rx_bloc_favorites_advanced/base/resources/color_styles.dart';

class IconWithShadow extends StatelessWidget {
  const IconWithShadow({
    this.icon,
    this.iconColor = ColorStyles.white,
    this.shadowColor = ColorStyles.shadow,
    Key? key,
  }) : super(key: key);

  final IconData? icon;
  final Color iconColor;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Positioned(
            left: 1,
            top: 2,
            child: Icon(icon, color: shadowColor),
          ),
          Icon(icon, color: iconColor),
        ],
      );
}
