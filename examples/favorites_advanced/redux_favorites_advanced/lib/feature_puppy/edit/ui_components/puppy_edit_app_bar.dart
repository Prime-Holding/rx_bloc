import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../../base/models/app_state.dart';
import '../views/puppy_edit_view_model.dart';

class PuppyEditAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PuppyEditAppBar({
    required bool enabled,
    //void Function()? onSavePressed,
    PuppyEditViewModel? viewModel,
    Key? key,
  })  : _enabled = enabled,
        //_onSavePressed = onSavePressed,
        _viewModel = viewModel,
        super(key: key);

  final bool _enabled;
  //final void Function()? _onSavePressed;
  final PuppyEditViewModel? _viewModel;

  double get loadingIndicatorSize => 24;

  @override
  Widget build(BuildContext context) => AppBar(
        title: const Text('Edit Puppy'),
        actions: [
          StoreConnector<AppState, PuppyEditViewModel>(
            builder: (_, viewModel) =>
                viewModel.isLoading ? _buildLoading() : _buildIcon(),
            converter: (store) => PuppyEditViewModel.from(store),
          ),
        ],
      );

  Widget _buildIcon() => IconButton(
        icon: Icon(
          Icons.save,
          color: _enabled ? Colors.white : Colors.grey,
        ),
        onPressed: () {
          if (_enabled) {
            //_onSavePressed?.call();
          }
        },
      );

  Widget _buildLoading() => IconButton(
        icon: Container(
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
