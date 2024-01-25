import 'package:rx_bloc_cli/src/extensions/string_extensions.dart';
import 'package:rx_bloc_cli/src/extensions/xml_extensions.dart';
import 'package:xml/xml.dart';

import '../common/string_processor.dart';

/// String processor used for processing of the iOS Plist file located at:
/// {project_root}/ios/Runner/Info.plist
class IOSPlistProcessor extends StringProcessor {
  /// iOS Plist processor constructor
  IOSPlistProcessor(super.args);

  String get _bundleId =>
      '${args.organisationDomain}.${args.organisationName}.${args.projectName}';

  @override
  String execute(String? input) {
    if (input == null) return '';
    final xmlDoc = XmlDocument.parse(input);

    // TODO: Apply some plist changes here

    return _parseToXmlString(xmlDoc);
  }

  /// region Private methods

  /// Converts the xml document to a prettified string format
  String _parseToXmlString(XmlDocument doc) => doc.toXmlString(pretty: true);

  /// endregion
}
