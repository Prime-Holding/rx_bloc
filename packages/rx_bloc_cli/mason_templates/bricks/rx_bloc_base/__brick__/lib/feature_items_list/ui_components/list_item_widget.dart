{{> licence.dart }}

import 'package:flutter/material.dart';

import '../../app_extensions.dart';
import '../../base/models/item_model.dart';

class ListItemWidget extends StatelessWidget {
  const ListItemWidget({
    required this.item,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final ItemModel item;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) => Material(
    child: InkWell(
      borderRadius: BorderRadius.all(
        Radius.circular(
          context.designSystem.spacing.xs,
        ),
      ),
      onTap: onTap,
      child: Ink(
        height: context.designSystem.spacing.xxxl,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: Colors.black)),
        child: Center(
          child: Text(item.name),
        ),
      ),
    ),
  );
}
