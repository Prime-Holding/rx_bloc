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

  {{#enable_feature_widget_toolkit}}
  final Icon widgetIcon = _getIcon(Icons.widgets);
  {{/enable_feature_widget_toolkit}}

  final Icon listIcon = _getIcon(Icons.list);

  final Icon accountIcon = _getIcon(Icons.account_box);

  final Icon logoutIcon = _getIcon(Icons.logout);

  final Icon linkIcon = _getIcon(Icons.link);

  final Icon dashboard = _getIcon(Icons.dashboard);
  {{#enable_mfa}}
  final Icon pin = _getIcon(Icons.pin);
  {{/enable_mfa}}
  {{#enable_feature_qr_scanner}}
  final Icon qrCode = _getIcon(Icons.qr_code);
  {{/enable_feature_qr_scanner}}
  static Icon _getIcon(IconData iconData) => Icon(iconData);
  
}
