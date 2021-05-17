import 'package:flutter/material.dart';
import 'package:flow_builder/flow_builder.dart';

import 'package:favorites_advanced_base/models.dart';

import '../../feature_puppy/details/views/puppy_details_view.dart';
import '../../feature_puppy/edit/views/puppy_edit_view.dart';

class PuppyFlowState {
  PuppyFlowState({
    required this.puppy,
    required this.manage,
  });

  final Puppy puppy;
  final bool manage;

  PuppyFlowState copyWith({
    Puppy? puppy,
    bool? manage,
  }) =>
      PuppyFlowState(
        puppy: puppy ?? this.puppy,
        manage: manage ?? this.manage,
      );
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
      PuppyEditView.page(puppy: state.puppy),
    ];
  }

  return [];
}

class PuppyFlow extends StatelessWidget {
  const PuppyFlow({
    required this.puppy,
    Key? key,
  }) : super(key: key);

  static Route<PuppyFlowState> route({required Puppy puppy}) =>
      MaterialPageRoute(builder: (_) => PuppyFlow(puppy: puppy));

  final Puppy puppy;

  @override
  Widget build(BuildContext context) => FlowBuilder(
        state: PuppyFlowState(
          puppy: puppy,
          manage: false,
        ),
        onGeneratePages: onGeneratePuppyPages,
      );
}
