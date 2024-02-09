import 'package:rx_bloc_cli/src/extensions/string_extensions.dart';
import 'package:rx_bloc_cli/src/extensions/xml_extensions.dart';
import 'package:xml/xml.dart';

import '../common/abstract_processors.dart';

/// String processor used for processing of the workspace file located at:
/// {project_root}/.idea/workspace.xml
class IdeaWorkspaceProcessor extends StringProcessor {
  /// Idea IDE Workspace processor constructor
  IdeaWorkspaceProcessor(super.args);

  @override
  String execute() {
    if (input == null) return '';
    final xmlDoc = XmlDocument.parse(input!);

    _setupDefaultFlavor(xmlDoc);

    return _parseToXmlString(xmlDoc);
  }

  /// region Private methods

  /// Converts the xml document to a prettified string following specified
  /// indentation rules.
  String _parseToXmlString(XmlDocument doc) => doc.toXmlString(
        pretty: true,
        indent: '  ',
      );

  void _setupDefaultFlavor(XmlDocument doc) {
    final defaultRunConfig =
        '<component name="RunManager" selected="Flutter.Development" />'
            .toXmlNode();
    doc.addNodeToElement('project', defaultRunConfig);
  }

  /// endregion
}
