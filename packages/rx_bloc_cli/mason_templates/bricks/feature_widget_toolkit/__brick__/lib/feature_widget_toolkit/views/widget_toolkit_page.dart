{{> licence.dart }}

import 'package:flutter/material.dart';

import '../../app_extensions.dart';
import 'common_components_page.dart';
import 'edit_fields_page.dart';
import 'pickers_page.dart';

class WidgetToolkitPage extends StatefulWidget {
  const WidgetToolkitPage({super.key});

  @override
  State<WidgetToolkitPage> createState() => _WidgetToolkitPageState();
}

class _WidgetToolkitPageState extends State<WidgetToolkitPage> {
  late PageController pageController;
  late String title;

  int nextPageIndex = 1;

  @override
  void initState() {
    pageController = PageController();

    maintainAppBar();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    title = context.l10n.featureWidgetToolkit.commonComponents;
  }

  void maintainAppBar() {
    pageController.addListener(() {
      if (pageController.page == 0) {
        setState(() {
          title = context.l10n.featureWidgetToolkit.commonComponents;
          nextPageIndex = 1;
        });
      }
      if (pageController.page == 1) {
        setState(() {
          title = context.l10n.featureWidgetToolkit.pickers;
          nextPageIndex = 2;
        });
      }
      if (pageController.page == 2) {
        setState(() {
          title = context.l10n.featureWidgetToolkit.editFields;
          nextPageIndex = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title), actions: [
          IconButton(
              onPressed: () {
                pageController.animateToPage(nextPageIndex,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.ease);
              },
              icon: const Icon(Icons.arrow_forward))
        ]),
        body: PageView(
          controller: pageController,
          children: <Widget>[
            CommonComponentsPage(
              pageController: pageController,
            ),
            PickersPage(
              pageController: pageController,
            ),
            EditFieldsPage(
              pageController: pageController,
            ),
          ],
        ),
      );

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
