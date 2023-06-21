import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../services/custom_sms_code_service.dart';
import '../views/otp_screen.dart';

class OtpScreenWithDependencies extends StatelessWidget {
  const OtpScreenWithDependencies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
        ],
        child: const OtpScreen(),
      );

  List<SingleChildWidget> get _services => [
        Provider<CustomSmsCodeService>(
          create: (context) => CustomSmsCodeService(context.read()),
        ),
      ];
}
