{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/common_ui_components/primary_button.dart';
import '../../base/extensions/error_model_field_translations.dart';
import '../../lib_auth_matrix/models/auth_matrix_action.dart';
import '../blocs/auth_matrix_edit_address_bloc.dart';
import '../services/auth_matrix_edit_address_service.dart';

class AuthMatrixPage extends StatelessWidget {
  const AuthMatrixPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.featureAuthMatrix.authMatrixAppBarTitle),
        ),
        body: Padding(
          padding: EdgeInsets.all(context.designSystem.spacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppErrorModalWidget<AuthMatrixEditAddressBlocType>(
                errorState: (bloc) => bloc.states.error,
              ),
              RxBlocListener<AuthMatrixEditAddressBlocType, AuthMatrixAction>(
                state: (bloc) => bloc.states.onAuthMatrixCompleted,
                listener: _showAuthMatrixComplete,
              ),
              Text(
                'The address component below demonstrates the 2FA (PIN and OTP) feature.',
                style: context.designSystem.typography.h2Med16,
              ),
              SizedBox(height: context.designSystem.spacing.m),
              EditAddressWidget<CountryModel>(
                translateError: (error) =>
                    ErrorModelFieldL10n.translateError<String>(error, context),
                service: context.read<AuthMatrixEditAddressService>(),
                onSaved: (address) {
                  context
                      .read<AuthMatrixEditAddressBlocType>()
                      .events
                      .saveAddress(
                        city: address.city,
                        streetAddress: address.streetAddress,
                        countryCode: address.country.countryCode,
                      );
                },
              ),
              Text(
                'Fill in the address fields and click save to trigger the 2FA process. \n '
                '- Use "0000" for the PIN and OTP code to complete the flow. \n '
                '- Use "3333" for OTP code to fail the flow.',
                style: context.designSystem.typography.h3Med11,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.designSystem.spacing.m,
                ),
                child: const Divider(),
              ),
              Text(
                'The button below demonstrates the 2FA (PIN) feature.',
                style: context.designSystem.typography.h2Med16,
              ),
              Center(
                child: PrimaryButton(
                  child: const Text('Unlock'),
                  onPressed: () => context
                      .read<AuthMatrixEditAddressBlocType>()
                      .events
                      .unlock(),
                ),
              ),
              SizedBox(height: context.designSystem.spacing.m),
              Text(
                'Tap on the button to trigger the 2FA process. \n'
                '- Use "0000" for the pin.',
                style: context.designSystem.typography.h3Med11,
              ),
            ],
          ),
        ),
      );

  void _showAuthMatrixComplete(BuildContext context, AuthMatrixAction action) =>
      showBlurredBottomSheet(
        context: context,
        builder: (BuildContext context) => MessagePanelWidget(
          message: action.name, // TODO: Replace with translation
          messageState: MessagePanelState.positive,
        ),
      );
}
