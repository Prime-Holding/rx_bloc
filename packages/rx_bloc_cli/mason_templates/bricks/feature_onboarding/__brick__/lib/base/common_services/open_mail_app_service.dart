{{> licence.dart }}

import 'package:open_mail/open_mail.dart';

import '../repositories/open_mail_app_repository.dart';

class OpenMailAppService {
  final OpenMailAppRepository _openMailAppRepository;

  OpenMailAppService(this._openMailAppRepository);

  Future<List<MailApp>> openMailApp(String title) =>
      _openMailAppRepository.openMailApp(title);
}
