import 'package:bloc_sample/base/flow_builders/puppy_flow.dart';
import 'package:bloc_sample/base/ui_components/icon_with_shadow.dart';
import 'package:bloc_sample/feature_puppy/blocs/puppy_manage_bloc.dart';
// import 'package:bloc_sample/feature_puppy/details/blocs/puppy_details_bloc.dart';
// import 'package:bloc_sample/feature_puppy/favorites/blocs/favorite_puppies_bloc.dart';
// import 'package:bloc_sample/feature_puppy/search/blocs/puppy_list_bloc.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/material.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        _buildFavoriteButton(context),
        _buildEditButton(context),
      ];

  Widget _buildFavoriteButton(BuildContext context) => _puppy.isFavorite
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
    BlocProvider.of<PuppyManageBloc>(context).add(
        PuppyManageMarkAsFavoriteEvent(
            puppy: _puppy, isFavorite: isFavorite));
    // BlocProvider.of<PuppyDetailsBloc>(context).add(
    //     PuppyDetailsEvent(puppy: _puppy)
    // );


  @override
  Size get preferredSize => const Size.fromHeight(56);
}
