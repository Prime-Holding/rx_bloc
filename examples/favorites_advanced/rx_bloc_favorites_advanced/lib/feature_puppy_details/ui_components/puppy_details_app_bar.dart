import 'package:auto_route/auto_route.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/material.dart';
import 'package:rx_bloc_favorites_advanced/base/routers/router.gr.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/details/blocs/puppy_manage_bloc.dart';

class PuppyDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PuppyDetailsAppBar({
    PuppyManageBlocType puppyManageBloc,
    Puppy puppy,
    Key key,
  })  : _puppy = puppy,
        _puppyManageBloc = puppyManageBloc,
        super(key: key);

  final PuppyManageBlocType _puppyManageBloc;
  final Puppy _puppy;

  @override
  Widget build(BuildContext context) => AppBar(
        title: const Text('Puppy Details'),
        centerTitle: true,
        actions: _buildTrailingItems(context),
      );

  List<Widget> _buildTrailingItems(BuildContext context) => [
        _buildFavouriteButton(context),
        _buildEditButton(context),
      ];

  Widget _buildFavouriteButton(BuildContext context) => _puppy.isFavorite
      ? IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () => _markAsFavorite(context, false),
        )
      : IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () => _markAsFavorite(context, true),
        );

  Widget _buildEditButton(BuildContext context) => IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => ExtendedNavigator.root.push(
          Routes.puppyEditPage,
          arguments: PuppyEditPageArguments(puppy: _puppy),
        ),
      );

  void _markAsFavorite(BuildContext context, bool isFavorite) =>
      _puppyManageBloc.events
          .markAsFavorite(puppy: _puppy, isFavorite: isFavorite);

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
