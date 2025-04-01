import 'package:app_links/app_links.dart';

class AppLinksDataSource {
  final _appLinks = AppLinks();

  Future<Uri?> getInitialLink() => _appLinks.getInitialLink();

  Stream<Uri> get uriLinkStream => _appLinks.uriLinkStream;
}