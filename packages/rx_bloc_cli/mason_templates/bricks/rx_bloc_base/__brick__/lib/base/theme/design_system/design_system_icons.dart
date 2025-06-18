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

  final phone = Icons.phone_outlined;

  final email = Icons.email_outlined;

  final phoneConfirm = Icons.sms_outlined;

  final send = Icons.send;

  final copy = Icons.copy;

  final success = Icons.check_circle_outline;

  final dashboardOutlined = Icons.dashboard_outlined;

  final key = Icons.key;

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
  final Icon qrCode = _getIcon(Icons.qr_code_scanner);
  {{/enable_feature_qr_scanner}}
  {{#has_showcase}}
  final Icon showcase = _getIcon(Icons.shelves);
  {{/has_showcase}} {{#enable_feature_otp}}
  final Icon otp = _getIcon(Icons.password);
  {{/enable_feature_otp}}
  {{#enable_pin_code}}
  final Icon fingerprint = _getIcon(Icons.fingerprint);
  {{/enable_pin_code}}
  final Icon notifications = _getIcon(Icons.notifications);

  final Icon notificationsActive = _getIcon(Icons.notifications_active);

  final Icon notificationsInactive = _getIcon(Icons.notifications_off);
  {{#enable_change_language}}
  final Icon language = _getIcon(Icons.language);
  {{/enable_change_language}}
  final Icon arrowForward = _getIcon(Icons.arrow_forward_ios);

  final Icon phoneIcon = _getIcon(Icons.phone_outlined);

  static Icon _getIcon(IconData iconData) => Icon(iconData);
  
}
