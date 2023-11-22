{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/widget_toolkit.dart';
import 'package:widget_toolkit_otp/widget_toolkit_otp.dart';

import '../../app_extensions.dart';
import '../../feature_otp/services/otp_text_field_validator.dart';
import '../../lib_router/blocs/router_bloc.dart';
import '../bloc/pin_otp_bloc.dart';
import '../models/auth_matrix_response.dart';
import '../services/auth_matrix_service.dart';

class AuthMatrixOtpPage extends StatelessWidget {
  const AuthMatrixOtpPage({
    required this.response,
    required this.endToEndId,
    super.key,
  });

  final AuthMatrixResponse response;
  final String endToEndId;

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          context
              .read<PinOtpBlocType>()
              .events
              .cancelAuthMatrix(response, endToEndId);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.featureOtp.otpPageTitle),
          ),
          body: SafeArea(
            child: SmsCodeProvider(
              onError: (p0, p1) => context.read<RouterBlocType>().events.pop(),
              sentNewCodeActivationTime: 2,
              smsCodeService: context.read<AuthMatrixService>(),
              builder: (state) => Padding(
                padding: EdgeInsets.all(context.designSystem.spacing.l),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SmsPhoneNumberField(
                      builder: (context, number, onChanged) => TextFieldDialog(
                        label: context.l10n.featureOtp.phoneNumber,
                        value: number,
                        validator: OtpTextFieldValidator(),
                        translateError: (Object error) => null,
                        onChanged: onChanged,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          context.l10n.featureOtp.hint,
                          style: TextStyle(
                              color: context.designSystem.colors.gray),
                        ),
                        SizedBox(height: context.designSystem.spacing.xs),
                        const SmsCodeField(),
                        SizedBox(height: context.designSystem.spacing.xs),
                        const ValidityWidget(),
                      ],
                    ),
                    SizedBox(
                      height: context.designSystem.spacing.xxxxl21,
                      child: Column(
                        children: [
                          ResendCodeButton(
                            activeStateIcon: Icon(
                              Icons.send,
                              color: context.designSystem.colors.primaryColor,
                            ),
                            pressedStateIcon: Icon(
                              Icons.check_circle_outline,
                              color: context
                                  .designSystem.colors.pinSuccessBorderColor,
                            ),
                          ),
                          const ResendButtonTimer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
