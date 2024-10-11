{{> licence.dart }}

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../app_extensions.dart';
import '../models/pin_code_arguments.dart';
import '../services/update_pin_code_service.dart';
import '../views/update_pin_page.dart';

class UpdatePinPageWithDependencies extends StatelessWidget {
  const UpdatePinPageWithDependencies({
    required this.pinCodeArguments,
    super.key,
  });

  final PinCodeArguments pinCodeArguments;

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services(context),
        ],
        child: UpdatePinPage(
          pinCodeArguments: pinCodeArguments,
        ),
      );

  List<SingleChildStatelessWidget> _services(BuildContext context) => [
        Provider<UpdatePinCodeService>(
          create: (_) => UpdatePinCodeService(
            context.read(),
            token: pinCodeArguments.updateToken,
            isVerificationPinProcess: pinCodeArguments.title ==
                context.l10n.libPinCode.enterCurrentPin,
          ),
        ),
      ];
}
