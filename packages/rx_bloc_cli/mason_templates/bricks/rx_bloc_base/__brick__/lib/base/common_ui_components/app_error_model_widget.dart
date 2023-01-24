{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:rx_bloc/rx_bloc.dart';

import '../../lib_navigation/blocs/navigation_bloc.dart';
import '../extensions/error_model_translations.dart';
import '../models/errors/error_model.dart';

typedef ErrorStateCallback<BlocType extends RxBlocTypeBase> = Stream<ErrorModel>
    Function(BlocType bloc);

class AppErrorModelWidget<BlocType extends RxBlocTypeBase>
    extends StatelessWidget {
  const AppErrorModelWidget({
    required this.errorState,
    this.isListeningForNavigationErrors = true,
    Key? key,
  }) : super(key: key);

  final ErrorStateCallback<BlocType> errorState;
  final bool isListeningForNavigationErrors;

  @override
  Widget build(BuildContext context) => Column(
      children: [
        RxBlocListener<BlocType, ErrorModel>(
          state: (bloc) => errorState(bloc),
          listener: _onError,
        ),
        if (isListeningForNavigationErrors)
        RxBlocListener<NavigationBlocType, ErrorModel>(
          state: (bloc) => bloc.states.errors,
          listener: (context, state) => _onError(context, state),
        ),
      ],
  );

  void _onError(BuildContext context, ErrorModel errorModel) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorModel.translate(context)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
