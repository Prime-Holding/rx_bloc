// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

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

  final Icon linkIcon = _getIcon(Icons.link);

  final Icon dashboard = _getIcon(Icons.dashboard);

  static Icon _getIcon(IconData iconData) => Icon(iconData);
}
