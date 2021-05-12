import 'package:bloc_sample/feature_puppy/blocs/puppy_manage_bloc.dart';
import 'package:bloc_sample/feature_puppy/edit/ui_components/puppy_edit_app_bar.dart';
import 'package:bloc_sample/feature_puppy/edit/ui_components/puppy_edit_form.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'puppy_edit_providers.dart';

class PuppyEditPage extends StatefulWidget {
  const PuppyEditPage({
    required Puppy? puppy,
    Key? key,
  })  : _puppy = puppy,
        super(key: key);

  static Page page({required Puppy? puppy}) => MaterialPage(
          child: MultiBlocProvider(
        providers: _getProviders(puppy),
        child: PuppyEditPage(puppy: puppy),
      ));

  final Puppy? _puppy;

  @override
  _PuppyEditPageState createState() => _PuppyEditPageState();
}

class _PuppyEditPageState extends State<PuppyEditPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<PuppyManageBloc, PuppyManageState>(
        builder: (context, state) => WillPopScope(
          onWillPop: () =>
              state.puppy! != null ? Future.value(false) : Future.value(true),
          child: BlocBuilder<PuppyManageBloc, PuppyManageState>(
            builder: (context, manageState) => Scaffold(
              appBar: PuppyEditAppBar(
                enabled: true,
                // onSavePressed: () => SavePuppyEvent(),
                onSavePressed: () => context
                    .read<PuppyManageBloc>()
                    .add(PuppyManageSavePuppyEvent()),
              ),
              body: PuppyEditForm(
                puppy: widget._puppy,
              ),
            ),
          ),
        ),
      );
}
