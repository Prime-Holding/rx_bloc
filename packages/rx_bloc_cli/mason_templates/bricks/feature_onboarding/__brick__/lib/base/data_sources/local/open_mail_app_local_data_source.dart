{{> licence.dart }}

import 'package:open_mail/open_mail.dart';

import '../../models/errors/error_model.dart';

class OpenMailAppDataSource {
  /// Opens the mail client/selection dialog with the given [title]
  Future<List<MailApp>> openMailApp(String title) async {
    var result = await OpenMail.openMailApp(
      nativePickerTitle: title,
    );

    if (!result.didOpen && !result.canOpen && result.options.isEmpty) {
      throw NoMailAppErrorModel();
    }

    return result.options;
  }
}
