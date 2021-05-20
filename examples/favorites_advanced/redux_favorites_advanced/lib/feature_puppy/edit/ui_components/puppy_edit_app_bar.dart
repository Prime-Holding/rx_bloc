import 'package:flutter/material.dart';

import '../views/puppy_edit_view_model.dart';

class PuppyEditAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PuppyEditAppBar({
    required GlobalKey<FormState> formKey,
    required PuppyEditViewModel viewModel,
    Key? key,
  })  : _formKey = formKey,
        _viewModel = viewModel,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final PuppyEditViewModel _viewModel;

  double get loadingIndicatorSize => 24;

  @override
  Widget build(BuildContext context) => AppBar(
        title: const Text('Edit Puppy'),
        actions: [
          if (_viewModel.isLoading) _buildLoading() else _buildIcon(),
        ],
      );

  Widget _buildIcon() => IconButton(
      icon: Icon(
        Icons.save,
        color: _viewModel.isChanged ? Colors.white : Colors.grey,
      ),
      onPressed: () => (_viewModel.isChanged)
          ? (_formKey.currentState!.validate())
              ? _viewModel.onSubmit()
              : null
          : null);

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
