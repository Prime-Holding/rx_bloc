{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../../base/extensions/error_model_field_translations.dart';
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
                /// TODO: To be updated after the new version of the widget_toolkit package is released. RxFieldException wrapper should be removed.
                RxFieldException(
                  error: ErrorModelFieldL10n.translateError<String>(
                      error, context),
                  fieldValue: '',
                ),
                label: 'First Name',
                value: 'John',
                validator: LocalAddressFieldService(),
                header: 'Enter your data',
              ),
            ),
          ],
        ),
      );
}
