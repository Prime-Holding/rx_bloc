import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:widget_toolkit/text_field_dialog.dart';
import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';

import '../../app_extensions.dart';
import '../services/custom_sms_code_service.dart';
import '../services/otp_text_field_validator.dart';
import '../views/otp_page.dart';

class OtpPageWithDependencies extends StatelessWidget {
  const OtpPageWithDependencies({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ..._services,
        ],
        child: OtpPage(
          appBar: AppBar(
            title: Text(context.l10n.featureOtp.otpPageTitle),
          ),
          otpLabel: Text(
            context.l10n.featureOtp.hint,
            style: TextStyle(color: context.designSystem.colors.gray),
          ),
          header: SmsPhoneNumberField(
            builder: (context, number, onChanged) => TextFieldDialog(
              label: context.l10n.featureOtp.phoneNumber,
              value: number,
              validator: OtpTextFieldValidator(),
              translateError: (Object error) => null,
              onChanged: onChanged,
            ),
          ),
        ),
      );

  List<SingleChildWidget> get _services => [
        Provider<SmsCodeService>(
          create: (context) => CustomSmsCodeService(context.read()),
        ),
      ];
}
