{{> licence.dart }}

import 'package:flutter/material.dart';
import 'package:widget_toolkit/widget_toolkit.dart';

import '../ui_components/loading_state_switcher.dart';
import '../ui_components/widget_section.dart';
import '../utils/utils.dart';
import 'widget_toolkit_page.dart';

class CommonComponentsPage extends StatelessWidget {
  const CommonComponentsPage({required this.pageController, Key? key})
      : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
            WidgetSection(
              description: 'OpenUrlWidget - launch URL link',
              child: OpenUrlWidget.withDependencies(
                url: 'https://www.primeholding.com/',
                translateError: translateError,
                child: const Text(
                  'https://www.primeholding.com/',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            WidgetSection(
              description: 'OpenUrlWidget - call a phone number',
              child: OpenUrlWidget.withDependencies(
                url: '+123456789012',
                uriType: UriType.telephone,
                translateError: translateError,
                child: const Text(
                  '+123456789012',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            LoadingStateSwitcher(
              builder: (isLoading, simulateLoading) => WidgetSection(
                description: 'Shimmer Wrapper',
                childSize: const Size(180, 120),
                onRefresh: () => simulateLoading.call(true),
                child: ShimmerWrapper(
                  showShimmer: isLoading,
                  fadeTransition: true,
                  alignment: Alignment.center,
                  child: Image.network(
                      'https://www.btsbg.org/sites/default/files/obekti/stobski-piramidi-selo-stob.jpg'),
                ),
              ),
            ),
            LoadingStateSwitcher(
              builder: (isLoading, simulateLoading) => WidgetSection(
                description: 'Text Shimmer',
                childSize: const Size(320, 32),
                onRefresh: () => simulateLoading.call(true),
                child: ShimmerText(
                  isLoading ? null : 'Displays Text after loaded',
                  alignment: Alignment.center,
                  type: ShimmerType.random(),
                ),
              ),
            ),
            WidgetSection(
              description: 'Modal Sheet with message',
              child: OutlineFillButton(
                text: 'Open modal sheet',
                onPressed: () => showBlurredBottomSheet(
                  context: context,
                  builder: (BuildContext context) => const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: MessagePanelWidget(
                        message: 'This is an informative message',
                        messageState: MessagePanelState.informative),
                  ),
                ),
              ),
            ),
            WidgetSection(
              description: 'Error Modal Sheet',
              child: GradientFillButton(
                text: 'Present error in modal',
                onPressed: () => showErrorBlurredBottomSheet(
                  error: 'This is an error message',
                  context: context,
                  retryCallback: (context) =>
                      Future.delayed(const Duration(seconds: 2)),
                ),
              ),
            ),
            WidgetSection(
              description: 'Buttons',
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: OutlineFillButton(
                      text: 'OutlineFillButton',
                      onPressed: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: GradientFillButton(
                      text: 'GradientFillButton',
                      onPressed: () {},
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: GradientFillButton(
                      text: 'GradientFillButton - disabled',
                      state: ButtonStateModel.disabled,
                      onPressed: null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: IconTextButton(
                      text: 'IconTextButton',
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
