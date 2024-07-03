import 'package:flutter/material.dart';
import 'package:widget_toolkit/shimmer.dart';

import '../../app_extensions.dart';

class StatLabelWidget extends StatelessWidget {
  const StatLabelWidget({super.key, required this.label, this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) =>
      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          label,
          style: context.designSystem.typography.h1Bold20,
        ),
        ShimmerText(
          value,
          alignment: Alignment.center,
          type: ShimmerType.proportional(trailingFlex: 5, leadingFlex: 1),
        )
      ]);
}
