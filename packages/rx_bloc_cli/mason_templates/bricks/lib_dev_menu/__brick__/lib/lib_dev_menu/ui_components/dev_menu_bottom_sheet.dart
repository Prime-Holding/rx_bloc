import 'package:alice/alice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/ui_components.dart';

import '../../app_extensions.dart';
import '../../base/data_sources/local/shared_preferences_instance.dart';
import '../../base/repositories/push_notification_repository.dart';
import '../extensions/dio_extension.dart';
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
                          const Text('Push notification token'),
                          SelectableText(snapshot.data!),
                          SizedBox(height: context.designSystem.spacing.m),
                        ],
                      )
                    : const SizedBox(),
              ),
              // FutureBuilder<String>(
              //   future: context.read<DeviceService>().getDeviceId(),
              //   builder: (context, snapshot) => snapshot.data != null
              //       ? Column(
              //           crossAxisAlignment: CrossAxisAlignment.stretch,
              //           children: [
              //             const Text('Device ID'),
              //             SelectableText(snapshot.data!),
              //             SizedBox(height: context.designSystem.spacing.m),
              //           ],
              //         )
              //       : const SizedBox(),
              // ),
              const Text(
                  'Please, enter the IP address of the computer from your local network - where you have the Software for Proxying Charles started.'),
              SizedBox(height: context.designSystem.spacing.m),
              const Text(
                  'After you save the IP, to apply the change, please restart your application!'),
              SizedBox(height: context.designSystem.spacing.m),
              TextFormField(
                autofocus: true,
                controller: _controller,
              ),
              SizedBox(height: context.designSystem.spacing.m),
              GradientFillButton(
                text: 'Save',
                areIconsClose: true,
                onPressed: () async {
                  await SharedPreferencesInstance()
                      .setString('proxy', _controller.text);

                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
              SizedBox(height: context.designSystem.spacing.m),
              GradientFillButton(
                text: 'Run HTTP Interceptor',
                areIconsClose: true,
                onPressed: () async {
                  context.read<Alice>().showInspector();
                  // if (mounted) {
                  //   Navigator.pop(context);
                  // }
                },
              ),
            ],
          ),
        ),
      );
}
