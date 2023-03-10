{{> licence.dart }}

import 'package:flutter/widgets.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../services/local_address_field_service.dart';
import '../ui_components/widget_section.dart';
import '../utils/utils.dart';

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
                errorMapper: (obj, context) =>
                    ErrorMapperUtil<String>().errorMapper(obj, context),
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
