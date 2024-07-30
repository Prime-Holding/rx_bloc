{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/app_error_modal_widget.dart';
import '../../base/common_ui_components/primary_button.dart';
import '../../base/extensions/error_model_field_translations.dart';
import '../../lib_tfa/models/tfa_action.dart';
import '../blocs/tfa_edit_address_bloc.dart';
import '../services/tfa_edit_address_service.dart';

class TFAPage extends StatelessWidget {
  const TFAPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.featureTfa.appBarTitle),
        ),
        body: Padding(
          padding: EdgeInsets.all(context.designSystem.spacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppErrorModalWidget<TFAEditAddressBlocType>(
                errorState: (bloc) => bloc.states.error,
              ),
              RxBlocListener<TFAEditAddressBlocType, TFAAction>(
                state: (bloc) => bloc.states.onTFACompleted,
                listener: _showTFAComplete,
              ),
              Text(
                context.l10n.featureTfa.changeAddressActionTitle,
                style: context.designSystem.typography.h2Med16,
              ),
              SizedBox(height: context.designSystem.spacing.m),
              EditAddressWidget<CountryModel>(
                translateError: (error) =>
                    ErrorModelFieldL10n.translateError<String>(error, context),
                service: context.read<TFAEditAddressService>(),
                onSaved: (address) {
                  context.read<TFAEditAddressBlocType>().events.saveAddress(
                        city: address.city,
                        streetAddress: address.streetAddress,
                        countryCode: address.country.countryCode,
                      );
                },
              ),
              Text(
                context.l10n.featureTfa.changeAddressActionDescription,
                style: context.designSystem.typography.h3Med11,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.designSystem.spacing.m,
                ),
                child: const Divider(),
              ),
              Text(
                context.l10n.featureTfa.unlockActionTitle,
                style: context.designSystem.typography.h2Med16,
              ),
              Center(
                child: PrimaryButton(
                  child: Text(context.l10n.featureTfa.unlockButtonText),
                  onPressed: () =>
                      context.read<TFAEditAddressBlocType>().events.unlock(),
                ),
              ),
              SizedBox(height: context.designSystem.spacing.m),
              Text(
                context.l10n.featureTfa.unlockActionDescription,
                style: context.designSystem.typography.h3Med11,
              ),
            ],
          ),
        ),
      );

  void _showTFAComplete(BuildContext context, TFAAction action) =>
      showBlurredBottomSheet(
        context: context,
        builder: (BuildContext context) => MessagePanelWidget(
          message: action.name,
          messageState: MessagePanelState.positive,
        ),
      );
}
