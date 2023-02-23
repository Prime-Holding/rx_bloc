{{> licence.dart }}

import 'package:flutter/material.dart';

@immutable
class DesignSystemIcons {
  DesignSystemIcons();

  final arrowBack = Icons.arrow_back;

  final plusSign = Icons.add;

  final minusSign = Icons.remove;

  final reload = Icons.update;

  final info = Icons.info;

  final login = Icons.login;

  final avatar = Icons.person;

  final message = Icons.message;

  final Icon calculateIcon = _getIcon(Icons.calculate);

  final Icon listIcon = _getIcon(Icons.list);

  final Icon accountIcon = _getIcon(Icons.account_box);

  final Icon logoutIcon = _getIcon(Icons.logout);

  static Icon _getIcon(IconData iconData) => Icon(iconData);
}
