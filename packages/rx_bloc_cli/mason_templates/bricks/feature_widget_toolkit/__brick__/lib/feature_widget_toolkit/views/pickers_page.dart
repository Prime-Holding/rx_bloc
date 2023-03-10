{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:widget_toolkit/edit_address.dart';
import 'package:widget_toolkit/item_picker.dart';
import 'package:widget_toolkit/language_picker.dart';
import 'package:widget_toolkit/search_picker.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../models/data_model.dart';
import '../repositories/search_repository.dart';
import '../services/data_service.dart';
import '../services/search_service.dart';
import '../ui_components/update_state_on_selection.dart';
import '../ui_components/widget_section.dart';

class PickersPage extends StatelessWidget {
  const PickersPage({required this.pageController, Key? key}) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
            WidgetSection(
              description: 'ItemPicker - single select',
              child: UpdateStateOnSelection<DataModel>(
                builder: (updatedData, updateFunction) => OutlineFillButton(
                  text: 'Select one item',
                  onPressed: () => showItemPickerBottomSheet<DataModel>(
                    context: context,
                    title: 'Select a single item',
                    selectedItems: updatedData,
                    callback: (data) => updateFunction.call(data),
                    service: DataService(),
                    configuration:
                        const ItemPickerConfiguration(isMultiSelect: false),
                  ),
                ),
              ),
            ),
            WidgetSection(
              description: 'ItemPicker - multi select',
              child: UpdateStateOnSelection<DataModel>(
                builder: (updatedData, updateFunction) => OutlineFillButton(
                  text: 'Select a few items',
                  onPressed: () => showItemPickerBottomSheet<DataModel>(
                      context: context,
                      title: 'Select a few items',
                      selectedItems: updatedData,
                      callback: (data) => updateFunction.call(data),
                      service: DataService(),
                      configuration:
                          const ItemPickerConfiguration(isMultiSelect: true)),
                ),
              ),
            ),
            WidgetSection(
              description: 'Search Picker',
              child: UpdateStateOnSelection<CountryModel>(
                getString: (CountryModel element) => element.itemDisplayName,
                builder: (updatedData, updateFunction) => OutlineFillButton(
                  text: 'Select an item from a long list',
                  onPressed: () => showSearchPickerBottomSheet<CountryModel>(
                      context: context,
                      title: 'Select country',
                      hintText: 'Type substring',
                      retryText: 'Retry',
                      selectedItem:
                          updatedData.isNotEmpty ? updatedData[0] : null,
                      onItemTap: (item) =>
                          updateFunction.call(item != null ? [item] : []),
                      service: SearchService(SearchCountryRepository()),
                      emptyBuilder: () => const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: MessagePanelWidget(
                              message:
                                  'There is no results for the searched query!',
                              messageState: MessagePanelState.neutral,
                            ),
                          ),
                      modalConfiguration: const SearchPickerModalConfiguration(
                          safeAreaBottom: true)),
                ),
              ),
            ),
          ],
        ),
      );
}
