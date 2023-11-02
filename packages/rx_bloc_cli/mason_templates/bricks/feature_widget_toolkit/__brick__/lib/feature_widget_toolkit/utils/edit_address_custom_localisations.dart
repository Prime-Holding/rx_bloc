import 'package:widget_toolkit/edit_address.dart';

import '../../app_extensions.dart';

class EditAddressCustomLocalisations extends EditAddressLocalizedStrings {
  EditAddressCustomLocalisations(super.context);

  @override
  String get countrySearchPickerTitle =>
      context.l10n.featureWidgetToolkit.editAddressCountrySearchPickerTitle;

  @override
  String get countrySearchPickerHintText =>
      context.l10n.featureWidgetToolkit.editAddressCountrySearchPickerHintText;

  @override
  String get countrySearchPickerRetryText =>
      context.l10n.featureWidgetToolkit.editAddressCountrySearchPickerRetryText;

  @override
  String get countryLabelText =>
      context.l10n.featureWidgetToolkit.editAddressCountryLabelText;

  @override
  String get cityButtonText =>
      context.l10n.featureWidgetToolkit.editAddressCityButtonText;

  @override
  String get cityLabelText =>
      context.l10n.featureWidgetToolkit.editAddressCityLabelText;

  @override
  String get cityEmptyLabel =>
      context.l10n.featureWidgetToolkit.editAddressCityEmptyLabel;

  @override
  String get addressButtonText =>
      context.l10n.featureWidgetToolkit.editAddressAddressButtonText;

  @override
  String get addressLabelText =>
      context.l10n.featureWidgetToolkit.editAddressAddressLabelText;

  @override
  String get addressEmptyLabel =>
      context.l10n.featureWidgetToolkit.editAddressAddressEmptyLabel;

  @override
  String get addressChangedMessage =>
      context.l10n.featureWidgetToolkit.editAddressAddressChangedMessage;

  @override
  String get cardFieldLabel =>
      context.l10n.featureWidgetToolkit.editAddressCardFieldLabel;

  @override
  String get saveButtonText =>
      context.l10n.featureWidgetToolkit.editAddressSaveButtonText;

  @override
  String get headerTitle =>
      context.l10n.featureWidgetToolkit.editAddressHeaderTitle;

  @override
  String get permanentAddressContentMessage => context
      .l10n.featureWidgetToolkit.editAddressPermanentAddressContentMessage;
}
