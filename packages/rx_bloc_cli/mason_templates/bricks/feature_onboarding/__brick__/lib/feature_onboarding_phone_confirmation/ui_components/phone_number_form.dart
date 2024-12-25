import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../../app_extensions.dart';
import '../../base/common_ui_components/primary_button.dart';
import '../../base/extensions/error_model_field_translations.dart';
import '../../base/models/country_code_model.dart';
import '../blocs/onboarding_phone_bloc.dart';
import '../services/search_country_code_service.dart';

class PhoneNumberForm extends StatelessWidget {
  const PhoneNumberForm({super.key});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          _buildSelectCountry(context),
          SizedBox(width: context.designSystem.spacing.xs),
          Expanded(
            child: _buildPhoneNumber(context),
          ),
        ],
      );

  /// region Builders

  Widget _buildSelectCountry(BuildContext context) =>
      RxBlocBuilder<OnboardingPhoneBlocType, CountryCodeModel?>(
        state: (bloc) => bloc.states.countryCode,
        builder: (context, countryCodeSnapshot, bloc) => PrimaryButton(
          onPressed: () => _onCountryCodeSegmentPressed(
            context,
            countryCodeSnapshot.data,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: context.designSystem.spacing.m,
            ),
            child: Text(
              '+${countryCodeSnapshot.data?.code ?? '1'}',
              textAlign: TextAlign.center,
              style: context.designSystem.typography.h2Reg16,
            ),
          ),
        ),
      );

  Widget _buildPhoneNumber(BuildContext context) =>
      RxTextFormFieldBuilder<OnboardingPhoneBlocType>(
        state: (bloc) => bloc.states.phoneNumber.translate(context),
        onChanged: (bloc, value) => bloc.events.setPhoneNumber(value),
        showErrorState: (bloc) => bloc.states.showErrors,
        builder: (fieldState) => TextFormField(
          textAlign: TextAlign.center,
          keyboardType: TextInputType.phone,
          controller: fieldState.controller,
          onEditingComplete: () =>
              FocusManager.instance.primaryFocus?.unfocus(),
          decoration: fieldState.decoration.copyWith(
            hintText:
                context.l10n.featureOnboarding.phoneNumberHint.toUpperCase(),
            errorText: fieldState.error,
            errorMaxLines: 2,
          ),
        ),
      );

  /// endregion

  /// region Callbacks and helpers

  void _onCountryCodeSegmentPressed(
    BuildContext context,
    CountryCodeModel? selectedCountryCode,
  ) =>
      showSearchPickerBottomSheet<CountryCodeModel>(
        context: context,
        title: context.l10n.featureOnboarding.selectCountry,
        hintText: context.l10n.featureOnboarding.typeSubstring,
        retryText: context.l10n.featureOnboarding.retry,
        selectedItem: selectedCountryCode,
        onItemTap: (item) {
          if (item == null) return;
          context.read<OnboardingPhoneBlocType>().events.setCountryCode(item);
          FocusManager.instance.primaryFocus?.unfocus();
        },
        service: context.read<SearchCountryCodeService>(),
        emptyBuilder: () => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.designSystem.spacing.xs1,
          ),
          child: MessagePanelWidget(
            message: context.l10n.featureOnboarding.thereAreNoResults,
            messageState: MessagePanelState.neutral,
          ),
        ),
        modalConfiguration: const SearchPickerModalConfiguration(
          safeAreaBottom: true,
        ),
      );

  /// endregion
}
