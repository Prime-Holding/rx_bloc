import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../services/custom_sms_code_service.dart';
import '../views/otp_page.dart';

class OtpPageWithDependencies extends StatelessWidget {
  const OtpPageWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
        ],
        child: const OtpPage(),
      );

  List<SingleChildWidget> get _services => [
        Provider<CustomSmsCodeService>(
          create: (context) => CustomSmsCodeService(context.read()),
        ),
      ];
}
