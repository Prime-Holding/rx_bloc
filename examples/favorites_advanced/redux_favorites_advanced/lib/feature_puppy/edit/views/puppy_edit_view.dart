import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flow_builder/flow_builder.dart';

import '../../../base/flow_builders/puppy_flow.dart';
import '../../../base/models/app_state.dart';
import '../ui_components/puppy_edit_app_bar.dart';
import '../ui_components/puppy_edit_form.dart';
import 'puppy_edit_view_model.dart';

class PuppyEditView extends StatelessWidget {
  const PuppyEditView({
    Key? key,
  }) : super(key: key);

  static Page page() => const MaterialPage(
        child: PuppyEditView(),
      );

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () => Future.value(true),
        child: StoreConnector<AppState, PuppyEditViewModel>(
          converter: (store) => PuppyEditViewModel.from(store),
          onDidChange: (viewModel, _) => (viewModel!.error != '')
              ? ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(viewModel.error)))
              : viewModel.isUpdated
                  ? {
                      context
                          .flow<PuppyFlowState>()
                          .update((_) => PuppyFlowState(manage: false)),
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('The puppy was updated successfully.')))
                    }
                  : null,
          builder: (_, viewModel) => Scaffold(
            appBar: PuppyEditAppBar(viewModel: viewModel),
            body: PuppyEditForm(viewModel: viewModel),
          ),
        ),
      );
}
