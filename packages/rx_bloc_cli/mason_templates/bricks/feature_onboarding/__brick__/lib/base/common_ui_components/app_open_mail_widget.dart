{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:open_mail/open_mail.dart';
import 'package:rx_bloc/rx_bloc.dart';

typedef AppOpenMailWidgetCallback<BlocType extends RxBlocTypeBase>
    = Stream<List<MailApp>> Function(BlocType bloc);

class AppOpenMailWidget<BlocType extends RxBlocTypeBase>
    extends StatelessWidget {
  const AppOpenMailWidget({super.key, required this.openMailState});

  final AppOpenMailWidgetCallback<BlocType> openMailState;

  @override
  Widget build(BuildContext context) => RxBlocListener<BlocType, List<MailApp>>(
      condition: (_, state) => state.isNotEmpty,
      listener: (context, state) async => await showDialog(
          context: context,
          builder: (_) => MailAppPickerDialog(
                mailApps: state,
              )),
      state: (bloc) => openMailState(bloc));
}
