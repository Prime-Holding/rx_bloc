{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:widget_toolkit/edit_address.dart';
import 'package:widget_toolkit/item_picker.dart';
import 'package:widget_toolkit/language_picker.dart';
import 'package:widget_toolkit/search_picker.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../l10n/l10n.dart';
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
              description:
                  context.l10n.featureWidgetToolkit.itemPickerSingleSelect,
              child: UpdateStateOnSelection<DataModel>(
                builder: (updatedData, updateFunction) => OutlineFillButton(
                  text: context.l10n.featureWidgetToolkit.selectOneItem,
                  onPressed: () => showItemPickerBottomSheet<DataModel>(
                    context: context,
                    title: context.l10n.featureWidgetToolkit.selectASingleItem,
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
              description:
                  context.l10n.featureWidgetToolkit.itemPickerMultiSelect,
              child: UpdateStateOnSelection<DataModel>(
                builder: (updatedData, updateFunction) => OutlineFillButton(
                  text: context.l10n.featureWidgetToolkit.selectAFewItems,
                  onPressed: () => showItemPickerBottomSheet<DataModel>(
                      context: context,
                      title: context.l10n.featureWidgetToolkit.selectAFewItems,
                      selectedItems: updatedData,
                      callback: (data) => updateFunction.call(data),
                      service: DataService(),
                      configuration:
                          const ItemPickerConfiguration(isMultiSelect: true)),
                ),
              ),
            ),
            WidgetSection(
              description: context.l10n.featureWidgetToolkit.searchPicker,
              child: UpdateStateOnSelection<CountryModel>(
                getString: (CountryModel element) => element.itemDisplayName,
                builder: (updatedData, updateFunction) => OutlineFillButton(
                  text: context
                      .l10n.featureWidgetToolkit.selectAnItemFromLongList,
                  onPressed: () => showSearchPickerBottomSheet<CountryModel>(
                    context: context,
                    title: context.l10n.featureWidgetToolkit.selectCountry,
                    hintText: context.l10n.featureWidgetToolkit.typeSubstring,
                    retryText: context.l10n.featureWidgetToolkit.retry,
                    selectedItem:
                        updatedData.isNotEmpty ? updatedData[0] : null,
                    onItemTap: (item) =>
                        updateFunction.call(item != null ? [item] : []),
                    service: SearchService(SearchCountryRepository()),
                    emptyBuilder: () => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: MessagePanelWidget(
                        message:
                            context.l10n.featureWidgetToolkit.thereAreNoResults,
                        messageState: MessagePanelState.neutral,
                      ),
                    ),
                    modalConfiguration: const SearchPickerModalConfiguration(
                        safeAreaBottom: true),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
