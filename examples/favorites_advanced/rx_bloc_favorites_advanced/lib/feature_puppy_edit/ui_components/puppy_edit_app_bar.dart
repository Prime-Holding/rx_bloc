import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy_edit/blocs/puppy_edit_bloc.dart';

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

  double get loadingIndicatorSize => 24;

  @override
  Widget build(BuildContext context) => RxBlocBuilder<PuppyEditBlocType, bool>(
        state: (bloc) => bloc.states.processingUpdate,
        builder: (context, loadingState, _) => AppBar(
          title: const Text('Edit Puppy'),
          actions: [
            _buildSaveButton(loadingState?.data ?? false),
          ],
        ),
      );

  Widget _buildSaveButton(bool isLoading) => IconButton(
        icon: !isLoading
            ? Icon(
                Icons.save,
                color: _enabled ? Colors.white : Colors.black38,
              )
            : Container(
                width: loadingIndicatorSize,
                height: loadingIndicatorSize,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
        onPressed: () => _enabled && !isLoading ? _onSavePressed?.call() : null,
      );

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
