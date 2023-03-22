{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/widget_toolkit.dart';
import '../../base/extensions/error_model_field_translations.dart';
import '../services/custom_edit_address_service.dart';
import '../services/local_address_field_service.dart';
import '../ui_components/widget_section.dart';

class EditFieldsPage extends StatelessWidget {
  const EditFieldsPage({required this.pageController, Key? key})
      : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
            WidgetSection(
              description: 'TextFieldDialog',
              child: TextFieldDialog<String>(
<<<<<<< HEAD
                translateError: (obj) =>
                    ErrorMapperUtil<String>().errorMapper(obj, context),
=======
                translateError: (error) =>
                    ErrorModelFieldL10n.translateError<String>(error, context),
>>>>>>> develop
                label: 'First Name',
                value: 'John',
                validator: LocalAddressFieldService(),
                header: 'Enter your data',
              ),
            ),
            WidgetSection(
              description: 'EditAddress',
              child: EditAddressWidget<CountryModel>(
                translateError: (error) =>
                    ErrorModelFieldL10n.translateError<String>(error, context),
                service:context.read<CustomEditAddressService<CountryModel>>(),
                onSaved: (address) => showBlurredBottomSheet(
                  context: context,
                  builder: (context) => MessagePanelWidget(
                    message: address.fullAddress,
                    messageState: MessagePanelState.informative,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
