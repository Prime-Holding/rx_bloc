{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/common_ui_components/primary_button.dart';
import '../../base/extensions/error_model_field_translations.dart';
import '../../lib_mfa/models/mfa_action.dart';
import '../blocs/mfa_edit_address_bloc.dart';
import '../services/mfa_edit_address_service.dart';

class MfaPage extends StatelessWidget {
  const MfaPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.featureMfa.appBarTitle),
        ),
        body: Padding(
          padding: EdgeInsets.all(context.designSystem.spacing.s),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppErrorModalWidget<MfaEditAddressBlocType>(
                errorState: (bloc) => bloc.states.error,
              ),
              RxBlocListener<MfaEditAddressBlocType, MfaAction>(
                state: (bloc) => bloc.states.onMfaCompleted,
                listener: _showMfaComplete,
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(context.designSystem.spacing.l),
                  child: Column(
                    children: [
                      Text(
                        context.l10n.featureMfa.changeAddressActionTitle,
                        style: context.designSystem.typography.h2Med16,
                      ),
                      SizedBox(height: context.designSystem.spacing.m),
                      EditAddressWidget<CountryModel>(
                        translateError: (error) =>
                            ErrorModelFieldL10n.translateError<String>(
                                error, context),
                        service: context.read<MfaEditAddressService>(),
                        onSaved: (address) {
                          context
                              .read<MfaEditAddressBlocType>()
                              .events
                              .saveAddress(
                                city: address.city,
                                streetAddress: address.streetAddress,
                                countryCode: address.country.countryCode,
                              );
                        },
                      ),
                      Text(
                        context.l10n.featureMfa.changeAddressActionDescription,
                        style: context.designSystem.typography.h3Med11,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: context.designSystem.spacing.l),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(context.designSystem.spacing.l),
                  child: Column(
                    children: [
                      Text(
                        context.l10n.featureMfa.unlockActionTitle,
                        style: context.designSystem.typography.h2Med16,
                      ),
                      Center(
                        child: PrimaryButton(
                          child: Text(context.l10n.featureMfa.unlockButtonText),
                          onPressed: () => context
                              .read<MfaEditAddressBlocType>()
                              .events
                              .unlock(),
                        ),
                      ),
                      SizedBox(height: context.designSystem.spacing.m),
                      Text(
                        context.l10n.featureMfa.unlockActionDescription,
                        style: context.designSystem.typography.h3Med11,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  void _showMfaComplete(BuildContext context, MfaAction action) =>
      showBlurredBottomSheet(
        context: context,
        builder: (BuildContext context) => MessagePanelWidget(
          message: action.name,
          messageState: MessagePanelState.positive,
        ),
      );
}
