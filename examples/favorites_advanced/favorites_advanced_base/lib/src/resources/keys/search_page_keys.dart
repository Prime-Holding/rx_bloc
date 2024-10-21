import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/foundation.dart';

const searchPageListKey = Key('searchPageList');
Key searchPageListItemById(String id) => Key('searchPageListItem$id');

const searchFieldKey = Key('searchField');
const hotelsFoundKey = Key('hotelsFound');

const sortFilterTapKey = Key('sortFilterTap');
const sortFilterApplyTapKey = Key('sortFilterApplyTap');
Key sortTypeTapKey(SortBy type) => Key('sortTypeTap$type');

const dateFilterTapKey = Key('dateFilterTap');
const dateFilterApplyTapKey = Key('dateFilterApplyTap');

const capacityFilterTapKey = Key('capacityFilterTap');
const capacityFilterApplyTapKey = Key('capacityFilterApplyTap');
Key setCapacityFilterActionKey(String action) =>
    Key('setCapacityFilterAction$action');
