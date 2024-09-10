import 'package:flutter/cupertino.dart';

import '../../app_extensions.dart';
import '../models/todos_filter_model.dart';

extension GetColor on TodosFilterModel? {
  Color getColor(BuildContext context, TodosFilterModel selectedFilter) =>
      this != null && this == selectedFilter
          ? context.designSystem.colors.activeButtonColor
          : context.designSystem.colors.inactiveButtonColor;
}

extension GetLabel on TodosFilterModel {
  String getLabel(BuildContext context) => switch (this) {
        TodosFilterModel.all => context.l10n.showAll,
        TodosFilterModel.incomplete => context.l10n.showActive,
        TodosFilterModel.completed => context.l10n.showCompleted,
      };
}
