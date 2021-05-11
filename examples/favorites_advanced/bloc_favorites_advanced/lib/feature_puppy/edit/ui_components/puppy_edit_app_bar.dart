import 'package:bloc_sample/feature_puppy/blocs/puppy_manage_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PuppyEditAppBar extends StatelessWidget implements PreferredSizeWidget{
  const PuppyEditAppBar({
    required bool enabled,
    void Function()? onSavePressed,
    Key? key,
}): _enabled = enabled,
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
    ]
  );

  Widget _buildSaveButton() => BlocBuilder<PuppyManageBloc, PuppyManageState>(
    builder: (context, state) =>
    state.puppy != null ? _buildLoading() : _buildIcon(),
  );

  Widget _buildIcon() => IconButton(
    icon: Icon(
      Icons.save,
      color: _enabled ? Colors.white : Colors.grey,
    ),
    onPressed: () {
      if(_enabled){
        _onSavePressed?.call();
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



















