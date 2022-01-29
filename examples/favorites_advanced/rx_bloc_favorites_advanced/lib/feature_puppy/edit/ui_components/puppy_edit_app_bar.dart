import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';

import '../../blocs/puppy_manage_bloc.dart';

class PuppyEditAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PuppyEditAppBar({
    required bool enabled,
    void Function()? onSavePressed,
    Key? key,
  })  : _enabled = enabled,
        _onSavePressed = onSavePressed,
        super(key: key);

  final bool _enabled;
  final void Function()? _onSavePressed;

  double get loadingIndicatorSize => 24;

  @override
  Widget build(BuildContext context) => AppBar(
        title: const Text('Edit Puppy'),
        actions: [
          _buildSaveButton(),
        ],
      );

  Widget _buildSaveButton() => RxBlocBuilder<PuppyManageBlocType, bool>(
        state: (bloc) => bloc.states.isLoading,
        builder: (context, isLoading, bloc) =>
            (isLoading.data ?? false) ? _buildLoading() : _buildIcon(),
      );

  Widget _buildIcon() => IconButton(
        icon: Icon(
          Icons.save,
          color: _enabled ? Colors.white : Colors.grey,
        ),
        onPressed: () {
          if (_enabled) {
            _onSavePressed?.call();
          }
        },
      );

  Widget _buildLoading() => IconButton(
        icon: SizedBox(
          width: loadingIndicatorSize,
          height: loadingIndicatorSize,
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        onPressed: () {},
      );

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
