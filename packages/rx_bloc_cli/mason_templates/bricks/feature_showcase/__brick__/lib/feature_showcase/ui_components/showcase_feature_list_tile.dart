{{> licence.dart }}

import 'package:flutter/material.dart';

import '../../app_extensions.dart';

class ShowcaseFeatureListTile extends StatelessWidget {
  const ShowcaseFeatureListTile({
    super.key,
    required this.onTap,
    required this.featureTitle,
    required this.featureSubtitle,
    required this.icon,
  });

  final void Function() onTap;
  final String featureTitle;
  final String featureSubtitle;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.designSystem.spacing.m,
        vertical: context.designSystem.spacing.xxxs,
      ),
      child: ListTile(
        title: Text(featureTitle),
        subtitle: Text(featureSubtitle),
        onTap: onTap,
        leading: icon,
      ),
    );
  }
}
