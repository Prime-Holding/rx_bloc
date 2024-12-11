import 'package:flutter/material.dart';
import 'package:flutter_rx_bloc/flutter_rx_bloc.dart';
import 'package:provider/provider.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../../app_extensions.dart';
import '../blocs/onboarding_phone_bloc.dart';
import '../models/country_code.dart';
import '../models/onboarding_phone_errors.dart';
import '../services/phone_number_formatter.dart';
import '../services/search_country_code_service.dart';

class PhoneNumberPicker extends StatelessWidget {
  const PhoneNumberPicker({
    this.countryCodeTextStyle,
    this.countryCodeBgColor = const Color(0xFFE1E1E1),
    this.phoneNumberHint = 'XX XXX XXXX',
    this.countryCodeHint = 'XXX',
    super.key,
  });

  /// The text style of the country code text
  final TextStyle? countryCodeTextStyle;

  /// Background color of the country code segment
  final Color countryCodeBgColor;

  /// The hint text of the country code input
  final String countryCodeHint;

  /// The hint text of the phone number input
  final String phoneNumberHint;

  static const double _borderRadius = 16.0;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RxBlocBuilder<OnboardingPhoneBlocType, CountryCodeModel?>(
                  state: (bloc) => bloc.states.countryCode,
                  builder: (context, countryCodeSnapshot, bloc) =>
                      _buildPhoneNumberPrefix(
                    context,
                    countryCodeSnapshot.data,
                  ),
                ),
                RxBlocBuilder<OnboardingPhoneBlocType, String>(
                  state: (bloc) => bloc.states.phoneNumber,
                  builder: (context, numberSnapshot, bloc) => Expanded(
                      child: _buildPhoneNumberInput(
                    context,
                    numberSnapshot.data ?? '',
                    phoneNumberHint,
                  )),
                ),
              ],
            ),
            RxBlocBuilder<OnboardingPhoneBlocType, ErrorModel?>(
              state: (bloc) => bloc.states.validationErrors,
              builder: (context, validationErrorSnapshot, bloc) =>
                  validationErrorSnapshot.data != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _translateError(
                                  context, validationErrorSnapshot.data!),
                              style: context.designSystem.typography.h2Reg16
                                  .copyWith(
                                color: context.designSystem.colors.errorColor,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      );

  /// region Builders

  Widget _buildPhoneNumberPrefix(
    BuildContext context,
    CountryCodeModel? selectedCountryCode,
  ) =>
      TextButton(
        onPressed: () => _onCountryCodeSegmentPressed(
          context,
          selectedCountryCode,
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_borderRadius),
              bottomLeft: Radius.circular(_borderRadius),
              topRight: Radius.zero,
              bottomRight: Radius.zero,
            ),
          ),
          backgroundColor: countryCodeBgColor,
        ),
        child: Text(
          '+${selectedCountryCode?.code ?? countryCodeHint}',
          style: countryCodeTextStyle ??
              TextStyle(
                color: context.designSystem.colors.primaryColor,
                fontSize: 16.0,
              ),
        ),
      );

  Widget _buildPhoneNumberInput(
    BuildContext context,
    String number,
    String hint,
  ) =>
      TextField(
        onChanged: (value) => context
            .read<OnboardingPhoneBlocType>()
            .events
            .setPhoneNumber(value),
        keyboardType: TextInputType.phone,
        inputFormatters: [PhoneNumberFormatter()],
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          contentPadding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(_borderRadius),
              bottomRight: Radius.circular(_borderRadius),
              topLeft: Radius.zero,
              bottomLeft: Radius.zero,
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
        },
        service: context.read<SearchCountryCodeService>(),
        emptyBuilder: () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: MessagePanelWidget(
            message: context.l10n.featureOnboarding.thereAreNoResults,
            messageState: MessagePanelState.neutral,
          ),
        ),
        modalConfiguration: const SearchPickerModalConfiguration(
          safeAreaBottom: true,
        ),
      );

  String _translateError(BuildContext context, Exception exception) {
    if (exception is InvalidCountryCodeError) {
      return context.l10n.featureOnboarding.invalidCountryCode;
    } else if (exception is InvalidPhoneNumberError) {
      return context.l10n.featureOnboarding.invalidPhoneNumber;
    } else if (exception is PhoneNumberTooShortError) {
      return context.l10n.featureOnboarding.phoneNumberTooShort;
    }

    return exception.toString();
  }

  /// endregion
}
