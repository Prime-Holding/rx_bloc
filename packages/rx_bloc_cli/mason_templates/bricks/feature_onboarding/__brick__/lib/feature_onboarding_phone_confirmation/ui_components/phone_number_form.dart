import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:flutter_rx_bloc/rx_form.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../../app_extensions.dart';
import '../../base/extensions/error_model_field_translations.dart';
import '../../base/models/country_code_model.dart';
import '../blocs/onboarding_phone_bloc.dart';
import '../services/search_country_code_service.dart';

class PhoneNumberForm extends StatefulWidget {
  const PhoneNumberForm({super.key});

  @override
  State<PhoneNumberForm> createState() => _PhoneNumberFormState();
}

class _PhoneNumberFormState extends State<PhoneNumberForm> {
  final _phoneNumberFocusNode = FocusNode(debugLabel: 'phoneNumberFocus');

  @override
  void initState() {
    super.initState();
    _phoneNumberFocusNode.requestFocus();
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      RxTextFormFieldBuilder<OnboardingPhoneBlocType>(
        state: (bloc) => bloc.states.phoneNumber.translate(context),
        onChanged: (bloc, value) => bloc.events.setPhoneNumber(value),
        showErrorState: (bloc) => bloc.states.showErrors,
        builder: (fieldState) => TextFormField(
          focusNode: _phoneNumberFocusNode,
          keyboardType: TextInputType.phone,
          controller: fieldState.controller,
          onEditingComplete: () =>
              FocusManager.instance.primaryFocus?.unfocus(),
          decoration: fieldState.decoration.copyWith(
            prefixIcon: _buildSelectCountry(context),
            hintText: context.l10n.featureOnboarding.phoneNumberHint,
            errorMaxLines: 2,
          ),
        ),
      );

  /// region Builders

  Widget _buildSelectCountry(BuildContext context) =>
      RxBlocBuilder<OnboardingPhoneBlocType, CountryCodeModel?>(
        state: (bloc) => bloc.states.countryCode,
        builder: (context, countryCodeSnapshot, bloc) => GestureDetector(
          onTap: () => _onCountryCodeSegmentPressed(
            context,
            countryCodeSnapshot.data,
          ),
          child: Container(
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(
                color: context.designSystem.colors.primaryColor,
                width: 2,
              ),
            )),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                context.designSystem.spacing.s,
                context.designSystem.spacing.xss1,
                context.designSystem.spacing.s,
                context.designSystem.spacing.s,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '+${countryCodeSnapshot.data?.code ?? ''}',
                    textAlign: TextAlign.center,
                    style: context.designSystem.typography.h2Reg16,
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: context.designSystem.colors.primaryColor,
                  ),
                ],
              ),
            ),
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
}
