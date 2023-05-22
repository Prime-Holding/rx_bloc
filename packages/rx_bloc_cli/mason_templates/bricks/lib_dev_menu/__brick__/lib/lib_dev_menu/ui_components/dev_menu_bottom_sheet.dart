{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../app_extensions.dart';
import '../../base/data_sources/local/shared_preferences_instance.dart';
import '../../base/repositories/push_notification_repository.dart';
import '../alice_instance.dart';
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
  const _DevMenuWidget({Key? key}) : super(key: key);

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
          context.designSystem.spacing.m +
              MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<String?>(
                future: context.read<PushNotificationRepository>().getToken(),
                builder: (context, snapshot) => snapshot.data != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(context.l10n.libDevMenu.token),
                          SelectableText(snapshot.data!),
                          SizedBox(height: context.designSystem.spacing.m),
                        ],
                      )
                    : const SizedBox(),
              ),
              Text(context.l10n.libDevMenu.enterIPAddress),
              SizedBox(height: context.designSystem.spacing.m),
              Text(context.l10n.libDevMenu.restartApp),
              SizedBox(height: context.designSystem.spacing.m),
              FutureBuilder(
                future: context
                    .read<SharedPreferencesInstance>()
                    .getString('proxy'),
                builder: (context, snapshot) {
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
                        alice.showInspector();
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
