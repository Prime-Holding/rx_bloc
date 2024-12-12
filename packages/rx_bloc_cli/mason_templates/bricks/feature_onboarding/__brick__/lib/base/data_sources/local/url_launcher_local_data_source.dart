{{> licence.dart }}

import 'package:url_launcher/url_launcher.dart';

import '../../models/errors/error_model.dart';

class UrlLauncherLocalDataSource {
  Future<void> openUri(String uri, bool isExternalApplicationMode) async =>
      await _launch(
        Uri.parse(uri),
        isExternalApplicationMode,
      );

  Future<void> _launch(
    Uri launchUri,
    bool isExternalApplicationMode,
  ) async {
    if (!(await canLaunchUrl(launchUri))) {
      throw InvalidUrlErrorModel();
    }

    await launchUrl(
      launchUri,
      mode: isExternalApplicationMode
          ? LaunchMode.externalApplication
          : LaunchMode.platformDefault,
    );
  }
}
