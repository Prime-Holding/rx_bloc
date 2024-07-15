import 'package:flutter/material.dart';

import '../../app_extensions.dart';
import 'statistic_widget.dart';

class StatsWidget extends StatelessWidget {
  const StatsWidget({super.key, this.completedCount, this.incompleteCount});

  final String? completedCount;
  final String? incompleteCount;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StatLabelWidget(
              label: context.l10n.completedTodos,
              value: completedCount,
            ),
            SizedBox(
              height: context.designSystem.spacing.l,
            ),
            StatLabelWidget(
              label: context.l10n.activeTodos,
              value: incompleteCount,
            ),
          ],
        ),
      );
}
