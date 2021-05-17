import 'package:flutter/material.dart';
import 'package:flow_builder/flow_builder.dart';

import 'package:favorites_advanced_base/models.dart';
import 'package:favorites_advanced_base/ui_components.dart';

import '../../../base/flow_builders/puppy_flow.dart';
import '../../details/views/puppy_details_view_model.dart';

class PuppyDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PuppyDetailsAppBar({
    required Puppy puppy,
    required PuppyDetailsViewModel viewModel,
    Key? key,
  })  : _puppy = puppy,
        _viewModel = viewModel,
        super(key: key);

  final Puppy _puppy;
  final PuppyDetailsViewModel _viewModel;

  @override
  Widget build(BuildContext context) => AppBar(
        leading: IconButton(
          icon: const IconWithShadow(icon: Icons.arrow_back),
          onPressed: () => context.flow<PuppyFlowState>().complete(),
        ),
        backgroundColor: Colors.transparent,
        actions: _buildTrailingItems(context),
        elevation: 0,
      );

  List<Widget> _buildTrailingItems(BuildContext context) => [
        _buildFavouriteButton(context),
        _buildEditButton(context),
      ];

  Widget _buildFavouriteButton(BuildContext context) => _puppy.isFavorite
      ? IconButton(
          icon: const IconWithShadow(icon: Icons.favorite),
          onPressed: () => _markAsFavorite(context, false),
        )
      : IconButton(
          icon: const IconWithShadow(icon: Icons.favorite_border),
          onPressed: () => _markAsFavorite(context, true),
        );

  Widget _buildEditButton(BuildContext context) => IconButton(
        icon: const IconWithShadow(icon: Icons.edit),
        onPressed: () async {
          context
              .flow<PuppyFlowState>()
              .update((state) => state.copyWith(manage: true));
        },
      );

  void _markAsFavorite(BuildContext context, bool isFavorite) =>
      _viewModel.onToggleFavorite(_puppy, isFavorite);

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
