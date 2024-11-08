{{> licence.dart }}


import 'package:flutter/material.dart';

import '../../app_extensions.dart';

class AppListTile extends StatelessWidget {
  const AppListTile(
      {super.key,
      required this.featureTitle,
      this.onTap,
      this.featureSubtitle,
      this.trailing,
      this.icon});

  final String featureTitle;
  final void Function()? onTap;
  final String? featureSubtitle;
  final Widget? trailing;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.designSystem.spacing.m,
        vertical: context.designSystem.spacing.xxxs,
      ),
      child: ListTile(
        title: Text(featureTitle),
        subtitle: (featureSubtitle != null) ? Text(featureSubtitle!) : null,
        onTap: onTap,
        leading: icon,
        trailing: trailing,
      ),
    );
  }
}
