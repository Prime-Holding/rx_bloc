import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_extensions.dart';
import '../../base/models/github_repo_model.dart';
import 'dashboard_search_delegate.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(context.designSystem.icons.search),
                onPressed: () async => await _showSearch(context),
              ),
            ),
          ],
        ),
        body: Center(child: Text(context.l10n.searchHint)),
      );

  Future<void> _showSearch(BuildContext context) async {
    final item = await showSearch<GithubRepoModel>(
      context: context,
      delegate: DashboardSearchDelegate(context.read()),
    );

    if (context.mounted && item != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.selectedItem(item.name)),
          action: SnackBarAction(
            label: context.l10n.open,
            onPressed: () async => await launchUrl(Uri.parse(item.url)),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
