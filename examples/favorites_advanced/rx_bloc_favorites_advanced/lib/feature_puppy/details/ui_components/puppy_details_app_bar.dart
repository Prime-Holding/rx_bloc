import 'package:auto_route/auto_route.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc_favorites_advanced/base/routers/router.gr.dart';
import 'package:rx_bloc_favorites_advanced/base/ui_components/icon_with_shadow.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/blocs/puppy_manage_bloc.dart';

class PuppyDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PuppyDetailsAppBar({
    Puppy puppy,
    Key key,
  })  : _puppy = puppy,
        super(key: key);

  final Puppy _puppy;

  @override
  Widget build(BuildContext context) => AppBar(
        leading: IconButton(
          icon: const IconWithShadow(icon: Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
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
          final result = await ExtendedNavigator.root.push(
            Routes.puppyEditPage,
            arguments: PuppyEditPageArguments(puppy: _puppy),
          );
          if (result != null && result) {
            Scaffold.of(context).showSnackBar(
              const SnackBar(
                content: Text('Puppy updated successfully.'),
              ),
            );
          }
        },
      );

  void _markAsFavorite(BuildContext context, bool isFavorite) =>
      RxBlocProvider.of<PuppyManageBlocType>(context)
          .events
          .markAsFavorite(puppy: _puppy, isFavorite: isFavorite);

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
