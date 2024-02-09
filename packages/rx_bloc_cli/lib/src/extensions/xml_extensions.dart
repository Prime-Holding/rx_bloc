import 'package:collection/collection.dart';

import 'package:xml/xml.dart';

/// Xml Attribute Node extensions
extension XmlAttributeExtensions on XmlAttribute {
  /// Returns the name of the node owning this attribute
  String? get elementName =>
      parentElement != null ? parentElement!.name.local : null;

  /// Retrieves the first found ancestor with provided tag [name] and optional
  /// attributes from the [hasAttributes] list. The ancestor node's attributes
  /// have to match all attribute names provided in the [hasAttributes] list.
  /// If no such node is found, `null` is returned.
  XmlElement? getAncestorWithName(
    String name, {
    List<String> hasAttributes = const [],
  }) {
    if (parentElement == null) return null;
    return parentElement!.ancestorElements.firstWhereOrNull((element) {
      if (element.name.local != name) return false;

      final attributeNames =
          element.attributes.map((att) => att.name.toString()).toSet();
      return attributeNames.containsAll(hasAttributes.toSet());
    });
  }
}

/// Xml Document Node extensions
extension XmlDocumentExtensions on XmlDocument {
  /// Looks for all elements with given name in the tree and returns the first
  /// one (if it exists). If none can be found, `null` is returned otherwise.
  XmlElement? getElementFirst(String name) => findAllElements(name).firstOrNull;

  /// Tries to add a [child] node to the first found element with provided
  /// [name] (if any). Adding is omitted if no such element can be found.
  XmlDocument addNodeToElement(String name, XmlNode child) {
    getElementFirst(name)?.children.add(child);
    return this;
  }

  /// Tries to add a list of [nodes] to the first found element with provided
  /// [name] (if any). Adding is omitted if no such element can be found.
  XmlDocument addNodesToElement(String name, List<XmlNode> nodes) {
    getElementFirst(name)?.children.addAll(nodes);
    return this;
  }
}
