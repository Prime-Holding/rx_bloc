import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../base/models/app_state.dart';
import '../ui_components/puppy_details.dart';
import 'puppy_details_view_model.dart';

class PuppyDetailsView extends StatelessWidget {
  const PuppyDetailsView({
    required PuppyDetailsViewModel viewModel,
    Key? key,
  })  : _viewModel = viewModel,
        super(key: key);

  static Page page() => MaterialPage(
        child: StoreConnector<AppState, PuppyDetailsViewModel>(
          distinct: true,
          converter: (store) => PuppyDetailsViewModel.from(store),
          builder: (_, viewModel) => PuppyDetailsView(
            viewModel: viewModel,
          ),
        ),
      );

  final PuppyDetailsViewModel _viewModel;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PuppyDetails(
          viewModel: _viewModel,
        ),
      );
}
