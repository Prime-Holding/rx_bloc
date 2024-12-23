{{> licence.dart }}

import 'package:open_mail/open_mail.dart';

import '../data_sources/local/open_mail_app_local_data_source.dart';

class OpenMailAppRepository {
  final OpenMailAppDataSource _openMailAppDataSource;

  OpenMailAppRepository(this._openMailAppDataSource);

  /// Opens the mail client/selection dialog with the given [title]
  Future<List<MailApp>> openMailApp(String title) =>
      _openMailAppDataSource.openMailApp(title);
}
