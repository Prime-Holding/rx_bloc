import 'package:widget_toolkit/edit_address.dart';

import '../../app_extensions.dart';

class EditAddressCustomLocalisations extends EditAddressLocalizedStrings {
  EditAddressCustomLocalisations(super.context);

  @override
  String get countrySearchPickerTitle =>
      context.l10n.editAddressCountrySearchPickerTitle;

  @override
  String get countrySearchPickerHintText =>
      context.l10n.editAddressCountrySearchPickerHintText;

  @override
  String get countrySearchPickerRetryText =>
      context.l10n.editAddressCountrySearchPickerRetryText;

  @override
  String get countryLabelText => context.l10n.editAddressCountryLabelText;

  @override
  String get cityButtonText => context.l10n.editAddressCityButtonText;

  @override
  String get cityLabelText => context.l10n.editAddressCityLabelText;

  @override
  String get cityEmptyLabel => context.l10n.editAddressCityEmptyLabel;

  @override
  String get addressButtonText => context.l10n.editAddressAddressButtonText;

  @override
  String get addressLabelText => context.l10n.editAddressAddressLabelText;

  @override
  String get addressEmptyLabel => context.l10n.editAddressAddressEmptyLabel;

  @override
  String get addressChangedMessage =>
      context.l10n.editAddressAddressChangedMessage;

  @override
  String get cardFieldLabel => context.l10n.editAddressCardFieldLabel;

  @override
  String get saveButtonText => context.l10n.editAddressSaveButtonText;

  @override
  String get headerTitle => context.l10n.editAddressHeaderTitle;

  @override
  String get permanentAddressContentMessage =>
      context.l10n.editAddressPermanentAddressContentMessage;
}
