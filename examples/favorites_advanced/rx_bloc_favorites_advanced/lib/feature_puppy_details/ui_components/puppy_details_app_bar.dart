import 'package:auto_route/auto_route.dart';
import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc_favorites_advanced/base/resources/color_styles.dart';
import 'package:rx_bloc_favorites_advanced/base/routers/router.gr.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/details/blocs/puppy_manage_bloc.dart';

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
          icon: _iconWithShadow(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        // title: const Text('Puppy Details'),
        actions: _buildTrailingItems(context),
        elevation: 0,
      );

  List<Widget> _buildTrailingItems(BuildContext context) => [
        _buildFavouriteButton(context),
        _buildEditButton(context),
      ];

  Widget _buildFavouriteButton(BuildContext context) => _puppy.isFavorite
      ? IconButton(
          icon: _iconWithShadow(Icons.favorite),
          onPressed: () => _markAsFavorite(context, false),
        )
      : IconButton(
          icon: _iconWithShadow(Icons.favorite_border),
          onPressed: () => _markAsFavorite(context, true),
        );

  Widget _buildEditButton(BuildContext context) => IconButton(
        icon: _iconWithShadow(Icons.edit),
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

  Widget _iconWithShadow(IconData icon) => Stack(
        children: <Widget>[
          Positioned(
            left: 1,
            top: 2,
            child: Icon(icon, color: ColorStyles.shadow),
          ),
          Icon(icon, color: ColorStyles.white),
        ],
      );

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
