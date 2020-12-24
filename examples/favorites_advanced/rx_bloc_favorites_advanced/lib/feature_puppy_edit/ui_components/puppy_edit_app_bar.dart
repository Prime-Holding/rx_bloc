import 'package:favorites_advanced_base/models.dart';
import 'package:flutter/material.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/details/blocs/puppy_manage_bloc.dart';

class PuppyEditAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PuppyEditAppBar({
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
        title: const Text('Edit Puppy'),
        centerTitle: true,
        actions: _buildTrailingItems(),
      );

  List<Widget> _buildTrailingItems() => [
        _buildSaveButton(),
      ];

  Widget _buildSaveButton() => IconButton(
        icon: const Icon(Icons.save),
        onPressed: () {
          // TODO: Save the changes made to the puppy
          debugPrint('Pressed "Save Puppy Changes" button');
        },
      );

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
