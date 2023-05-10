{{> licence.dart }}

import 'package:alice/alice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_extensions.dart';
import '../../base/data_sources/local/shared_preferences_instance.dart';
import '../../base/extensions/dio_extension.dart';
import '../../base/repositories/push_notification_repository.dart';
import 'app_modal_bottom_sheet.dart';

void showAppDevMenuBottomSheet(BuildContext context) => showAppModalBottomSheet(
      applySafeArea: true,
      context: context,
      hideCloseButton: true,
      hideTheLine: true,
      builder: (ctx) => const _DevMenuWidget(),
      onDonePressed: () => Navigator.of(context).pop(),
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
    _controller = TextEditingController(text: DioFactoryX.proxy);
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
              TextFormField(
                autofocus: true,
                controller: _controller,
              ),
              SizedBox(height: context.designSystem.spacing.l),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        await SharedPreferencesInstance().setString(
                            context.l10n.libDevMenu.proxy, _controller.text);

                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: context.designSystem.spacing.m),
                        child: Text(context.l10n.libDevMenu.save),
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
                        child: Text(context.l10n.libDevMenu.runInterceptor),
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
