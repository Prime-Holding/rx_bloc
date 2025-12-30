{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/widget_toolkit.dart';
import '../../base/extensions/error_model_field_translations.dart';
import '../../l10n/l10n.dart';
import '../services/custom_edit_address_service.dart';
import '../services/local_address_field_service.dart';
import '../ui_components/widget_section.dart';
import '../utils/edit_address_custom_localisations.dart';

class EditFieldsPage extends StatelessWidget {
  const EditFieldsPage({
    required this.pageController,
    super.key,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
            WidgetSection(
              description: context.l10n.textFieldDialog,
              child: TextFieldDialog<String>(
                translateError: (error) =>
                    ErrorModelFieldL10n.translateError<String>(error, context),
                label: context.l10n.textFieldLabel,
                value: context.l10n.nameValue,
                validator: LocalAddressFieldService(),
                header: context.l10n.headerValue,
                fillButtonText:
                    context.l10n.textFieldButtonText,
              ),
            ),
            WidgetSection(
              description: context.l10n.editAddress,
              child: EditAddressWidget<CountryModel>(
                translateError: (error) =>
                    ErrorModelFieldL10n.translateError<String>(error, context),
                service: context.read<CustomEditAddressService<CountryModel>>(),
                onSaved: (address) => showBlurredBottomSheet(
                  context: context,
                  builder: (context) => MessagePanelWidget(
                    message: address.fullAddress,
                    messageState: MessagePanelState.informative,
                  ),
                ),
                localizedStrings:
                    context.read<EditAddressCustomLocalisations>(),
              ),
            ),
          ],
        ),
      );
}
