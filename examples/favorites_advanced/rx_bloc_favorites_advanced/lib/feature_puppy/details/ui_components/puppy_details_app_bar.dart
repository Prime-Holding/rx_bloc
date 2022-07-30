import 'package:favorites_advanced_base/models.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../../../base/flow_builders/puppy_flow.dart';
import '../../../base/ui_components/icon_with_shadow.dart';
import '../../blocs/puppy_manage_bloc.dart';

class PuppyDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PuppyDetailsAppBar({
    required Puppy puppy,
    Key? key,
  })  : _puppy = puppy,
        super(key: key);

  final Puppy _puppy;

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

          // if (result != null && result) {
          //   Scaffold.of(context).showSnackBar(
          //     const SnackBar(
          //       content: Text('Puppy updated successfully.'),
          //     ),
          //   );
          // }
        },
      );

  void _markAsFavorite(BuildContext context, bool isFavorite) =>
      RxBlocProvider.of<PuppyManageBlocType>(context)
          .events
          .markAsFavorite(puppy: _puppy, isFavorite: isFavorite);

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
