import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:provider/provider.dart';

import '../../blocs/puppy_manage_bloc.dart';
import '../../validators/puppy_validator.dart';
import '../ui_components/puppy_edit_app_bar.dart';
import '../ui_components/puppy_edit_form.dart';

part 'puppy_edit_providers.dart';

class PuppyEditPage extends StatefulWidget {
  const PuppyEditPage({
    required Puppy? puppy,
    Key? key,
  })  : _puppy = puppy,
        super(key: key);

  static Page page({required Puppy? puppy}) => MaterialPage(
        child: RxMultiBlocProvider(
          providers: _getProviders(puppy),
          child: PuppyEditPage(puppy: puppy),
        ),
      );

  final Puppy? _puppy;

  @override
  State<PuppyEditPage> createState() => _PuppyEditPageState();
}

class _PuppyEditPageState extends State<PuppyEditPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      RxBlocBuilder<PuppyManageBlocType, bool>(
        state: (bloc) => bloc.states.isLoading,
        builder: (context, isLoading, _) => WillPopScope(
          onWillPop: () =>
              isLoading.data! ? Future.value(false) : Future.value(true),
          child: RxUnfocuser(
            child: RxBlocBuilder<PuppyManageBlocType, bool>(
              state: (bloc) => bloc.states.isSaveEnabled,
              builder: (context, saveEnabled, editBloc) => Scaffold(
                appBar: PuppyEditAppBar(
                  enabled: saveEnabled.data ?? true,
                  onSavePressed: () => editBloc.events.savePuppy(),
                ),
                body: PuppyEditForm(
                  puppy: widget._puppy,
                ),
              ),
            ),
          ),
        ),
      );
}
