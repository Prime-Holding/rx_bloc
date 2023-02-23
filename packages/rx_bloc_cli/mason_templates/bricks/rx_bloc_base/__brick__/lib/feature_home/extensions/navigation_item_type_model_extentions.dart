{{> licence.dart }}

import 'package:flutter/material.dart';

import '../../app_extensions.dart';
import '../models/navigation_item_type_model.dart';

extension NavigationItemTypeModelX on NavigationItemTypeModel {
  String getTitle(BuildContext context) {
    switch (this) {
      case NavigationItemTypeModel.counter:
        return context.l10n.navCounter;
      case NavigationItemTypeModel.items:
        return context.l10n.navItems;
      case NavigationItemTypeModel.profile:
        return context.l10n.navProfile;
    }
  }

  Icon getIcon(BuildContext context) {
    switch (this) {
      case NavigationItemTypeModel.counter:
        return context.designSystem.icons.calculateIcon;
      case NavigationItemTypeModel.items:
        return context.designSystem.icons.listIcon;
      case NavigationItemTypeModel.profile:
        return context.designSystem.icons.accountIcon;
    }
  }
}
