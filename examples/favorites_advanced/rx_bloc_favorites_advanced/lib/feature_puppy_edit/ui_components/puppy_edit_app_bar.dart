import 'package:flutter/material.dart';

class PuppyEditAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PuppyEditAppBar({
    @required bool enabled,
    Function() onSavePressed,
    Key key,
  })  : _enabled = enabled,
        _onSavePressed = onSavePressed,
        super(key: key);

  final bool _enabled;
  final Function() _onSavePressed;

  @override
  Widget build(BuildContext context) => AppBar(
        title: const Text('Edit Puppy'),
        centerTitle: true,
        actions: [
          _buildSaveButton(),
        ],
      );

  Widget _buildSaveButton() => IconButton(
        icon: Icon(
          Icons.save,
          color: _enabled ? Colors.white : Colors.black38,
        ),
        onPressed: () => _enabled ? _onSavePressed?.call() : null,
      );

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
