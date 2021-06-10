import 'package:flutter/material.dart';

import 'package:favorites_advanced_base/resources.dart';

class EditFormItem extends StatelessWidget {
  const EditFormItem({
    required IconData icon,
    required String title,
    required Widget formField,
    Key? key,
  })  : _title = title,
        _icon = icon,
        _formField = formField,
        super(key: key);

  final IconData _icon;
  final String _title;
  final Widget _formField;

  @override
  Widget build(BuildContext context) => Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    _icon,
                    color: Colors.black54,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    _title,
                    style: TextStyles.editableTextStyle
                        .copyWith(color: Colors.black54),
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
              ),
              _formField,
            ],
          ),
        ),
      );
}
