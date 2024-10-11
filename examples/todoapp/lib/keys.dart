import 'package:flutter/foundation.dart';

import 'base/models/todos_filter_model.dart';
import 'lib_todo_actions/models/bulk_action.dart';

typedef K = Keys;

class Keys {
  const Keys();

  static const bottomNavigationBar = Key('bottomNavigationBar');
  static const todoTitleTextField = Key('todoTitleTextField');
  static const todoDescriptionTextField = Key('todoDescriptionTextField');
  static const todoManagementPageFAB = Key('todoManagementPageFAB');
  static const todoAddFAB = Key('todoAddFAB');
  static const todoDetailsPageDeleteButton = Key('todoDetailsPageDeleteButton');
  static const todoDetailsPageEditButton = Key('todoDetailsPageEditButton');
  static const actionsButton = Key('actionsButton');
  static const filtersButton = Key('filtersButton');
  static const todoListPageCreateButton = Key('todoListPageCreateButton');
  static const todosList = Key('todosList');

  static Key todoCheckboxByIndex(String index) {
    return Key('todoCheckboxByIndex-$index');
  }

  static Key filterByName(TodosFilterModel filter) {
    return Key('filterByName-${filter.name}');
  }

  static Key actionByName(BulkActionModel actionName) {
    return Key('actionByName-$actionName');
  }
}
