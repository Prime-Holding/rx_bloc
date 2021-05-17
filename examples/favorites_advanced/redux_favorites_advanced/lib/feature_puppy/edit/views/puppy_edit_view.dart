import 'package:flutter/material.dart';

import 'package:favorites_advanced_base/models.dart';

import '../ui_components/puppy_edit_app_bar.dart';
import '../ui_components/puppy_edit_form.dart';

class PuppyEditView extends StatelessWidget {
  const PuppyEditView({
    required Puppy puppy,
    Key? key,
  })  : _puppy = puppy,
        super(key: key);

  final Puppy _puppy;

  static Page page({required Puppy puppy}) => MaterialPage(
        child: PuppyEditView(puppy: puppy),
      );

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () => Future.value(true),
        child: Scaffold(
          appBar: const PuppyEditAppBar(enabled: false),
          body: PuppyEditForm(
            puppy: _puppy,
          ),
        ),
      );
}
