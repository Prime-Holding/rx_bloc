import 'package:auto_route/auto_route.dart';
import 'package:favorites_advanced_base/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:provider/provider.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/blocs/puppy_manage_bloc.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/edit/ui_components/puppy_edit_app_bar.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/edit/ui_components/puppy_edit_form.dart';
import 'package:rx_bloc_favorites_advanced/feature_puppy/validators/puppy_validator.dart';

part 'puppy_edit_providers.dart';

class PuppyEditPage extends StatefulWidget with AutoRouteWrapper {
  const PuppyEditPage({
    @required Puppy puppy,
    Key key,
  })  : _puppy = puppy,
        super(key: key);

  final Puppy _puppy;

  @override
  Widget wrappedRoute(BuildContext context) => RxMultiBlocProvider(
        providers: _getProviders(_puppy),
        child: this,
      );

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
      RxBlocBuilder<PuppyManageBlocType, bool>(
        state: (bloc) => bloc.states.processingUpdate,
        builder: (context, isProcessingUpdate, _) => WillPopScope(
          onWillPop: () => Future.value(!(isProcessingUpdate?.data ?? false)),
          child: RxBlocBuilder<PuppyManageBlocType, Puppy>(
            state: (bloc) => bloc.states.puppy,
            builder: (context, puppy, bloc) => RxUnfocuser(
              child: RxBlocBuilder<PuppyManageBlocType, bool>(
                state: (bloc) => bloc.states.isSaveEnabled,
                builder: (context, saveEnabled, editBloc) => Scaffold(
                  appBar: PuppyEditAppBar(
                    enabled: saveEnabled?.data ?? false,
                    onSavePressed: () => editBloc.events.updatePuppy(),
                  ),
                  body: PuppyEditForm(
                    tag: '$PuppyCardAnimationTag '
                        '${puppy.data?.id ?? widget._puppy.id}',
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
