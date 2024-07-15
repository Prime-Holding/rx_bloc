// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:alice/alice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../app_extensions.dart';
import '../blocs/dev_menu_bloc.dart';

void showAppDevMenuBottomSheet(BuildContext context) => showBlurredBottomSheet(
      configuration: const ModalConfiguration(
        safeAreaBottom: true,
        showCloseButton: false,
        isDismissible: true,
        showHeaderPill: true,
        haveOnlyOneSheet: true,
      ),
      context: context,
      builder: (ctx) => const _DevMenuWidget(),
    );

class _DevMenuWidget extends StatefulWidget {
  const _DevMenuWidget();

  @override
  State<StatefulWidget> createState() => _DevMenuState();
}

class _DevMenuState extends State<_DevMenuWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(
          context.designSystem.spacing.m,
          context.designSystem.spacing.m,
          context.designSystem.spacing.m,
          context.designSystem.spacing.m,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(context.l10n.libDevMenu.enterIPAddress),
              SizedBox(height: context.designSystem.spacing.m),
              Text(context.l10n.libDevMenu.restartApp),
              SizedBox(height: context.designSystem.spacing.m),
              RxBlocBuilder<DevMenuBlocType, String?>(
                state: (bloc) => bloc.states.getProxy,
                builder: (context, snapshot, bloc) {
                  _controller.text = snapshot.data ?? '';
                  return TextFormField(
                    autofocus: true,
                    controller: _controller,
                  );
                },
              ),
              SizedBox(height: context.designSystem.spacing.l),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: RxBlocBuilder<DevMenuBlocType, void>(
                      state: (bloc) => bloc.states.proxySaved,
                      builder: (context, snapshot, bloc) => FilledButton(
                        onPressed: () {
                          bloc.events.saveProxy(_controller.text);

                          if (mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: context.designSystem.spacing.m),
                          child: Text(
                            context.l10n.libDevMenu.save,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: context.designSystem.spacing.s,
                  ),
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        context.read<Alice>().showInspector();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: context.designSystem.spacing.m),
                        child: Text(
                          context.l10n.libDevMenu.runInterceptor,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
