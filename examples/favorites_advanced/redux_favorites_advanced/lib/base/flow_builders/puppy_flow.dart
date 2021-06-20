import 'package:flutter/material.dart';
import 'package:flow_builder/flow_builder.dart';

import '../../feature_puppy/details/views/puppy_details_view.dart';
import '../../feature_puppy/edit/views/puppy_edit_view.dart';

class PuppyFlowState {
  PuppyFlowState({
    required this.manage,
  });

  final bool manage;
}

List<Page> onGeneratePuppyPages(PuppyFlowState state, List<Page> pages) {
  if (state.manage == false) {
    return [
      PuppyDetailsView.page(),
    ];
  }

  if (state.manage == true) {
    return [
      PuppyDetailsView.page(),
      PuppyEditView.page(),
    ];
  }

  return [];
}

class PuppyFlow extends StatelessWidget {
  const PuppyFlow({
    Key? key,
  }) : super(key: key);

  static Route<PuppyFlowState> route() =>
      MaterialPageRoute(builder: (_) => const PuppyFlow());

  @override
  Widget build(BuildContext context) => FlowBuilder(
        state: PuppyFlowState(manage: false),
        onGeneratePages: onGeneratePuppyPages,
      );
}
