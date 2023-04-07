{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../../l10n/l10n.dart';
import '../ui_components/loading_state_switcher.dart';
import '../ui_components/widget_section.dart';
import '../utils/utils.dart';

class CommonComponentsPage extends StatelessWidget {
  const CommonComponentsPage({required this.pageController, Key? key})
      : super(key: key);

  final PageController pageController;
  static const String _imageUrl =
      'https://www.btsbg.org/sites/default/files/obekti/stobski-piramidi-selo-stob.jpg';

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
            WidgetSection(
              description:
                  context.l10n.featureWidgetToolkit.openUrlWidgetLaunchURLLink,
              child: OpenUrlWidget.withDependencies(
                url: context.l10n.featureWidgetToolkit.primeHoldingUrl,
                translateError: translateError,
                child: Text(
                  context.l10n.featureWidgetToolkit.primeHoldingUrl,
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            WidgetSection(
              description: context
                  .l10n.featureWidgetToolkit.openUrlWidgetCallAPhoneNumber,
              child: OpenUrlWidget.withDependencies(
                url: context.l10n.featureWidgetToolkit.phoneNumber,
                uriType: UriType.telephone,
                translateError: translateError,
                child: Text(
                  context.l10n.featureWidgetToolkit.phoneNumber,
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            LoadingStateSwitcher(
              builder: (isLoading, simulateLoading) => WidgetSection(
                description: context.l10n.featureWidgetToolkit.shimmerWrapper,
                childSize: const Size(180, 120),
                onRefresh: () => simulateLoading.call(true),
                child: ShimmerWrapper(
                  showShimmer: isLoading,
                  fadeTransition: true,
                  alignment: Alignment.center,
                  child: Image.network(_imageUrl),
                ),
              ),
            ),
            LoadingStateSwitcher(
              builder: (isLoading, simulateLoading) => WidgetSection(
                description: context.l10n.featureWidgetToolkit.textShimmer,
                childSize: const Size(320, 32),
                onRefresh: () => simulateLoading.call(true),
                child: ShimmerText(
                  isLoading
                      ? null
                      : context
                          .l10n.featureWidgetToolkit.displaysTextAfterLoaded,
                  alignment: Alignment.center,
                  type: ShimmerType.random(),
                ),
              ),
            ),
            WidgetSection(
              description:
                  context.l10n.featureWidgetToolkit.modalSheetWithMessage,
              child: OutlineFillButton(
                text: context.l10n.featureWidgetToolkit.openModalSheet,
                onPressed: () => showBlurredBottomSheet(
                  context: context,
                  builder: (BuildContext context) => Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: MessagePanelWidget(
                        message: context.l10n.featureWidgetToolkit
                            .thisIsAnInformativeMessage,
                        messageState: MessagePanelState.informative),
                  ),
                ),
              ),
            ),
            WidgetSection(
              description: context.l10n.featureWidgetToolkit.errorModalSheet,
              child: GradientFillButton(
                text: context.l10n.featureWidgetToolkit.presentErrorInModal,
                onPressed: () => showErrorBlurredBottomSheet(
                  error: context.l10n.featureWidgetToolkit.thisIsAnErrorMessage,
                  context: context,
                  retryCallback: (context) =>
                      Future.delayed(const Duration(seconds: 2)),
                  retryButtonText: context.l10n.featureWidgetToolkit.retry,
                ),
              ),
            ),
            WidgetSection(
              description: context.l10n.featureWidgetToolkit.buttons,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: OutlineFillButton(
                      text: context.l10n.featureWidgetToolkit.outlineFillButton,
                      onPressed: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: GradientFillButton(
                      text:
                          context.l10n.featureWidgetToolkit.gradientFillButton,
                      onPressed: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: GradientFillButton(
                      text: context
                          .l10n.featureWidgetToolkit.gradientFillButtonDisabled,
                      state: ButtonStateModel.disabled,
                      onPressed: null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: IconTextButton(
                      text: context.l10n.featureWidgetToolkit.iconTextButton,
                      icon: Icons.send_time_extension_outlined,
                      onPressed: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: SmallButton(
                      onPressed: () {},
                      icon: Icons.home_work_outlined,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
