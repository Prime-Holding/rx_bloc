import '../common/abstract_processors.dart';

/// String processor used for processing github workflow files (.yaml)
class CICDConfigFileProcessor extends StringProcessor {
  /// Github Workflow processor constructor
  CICDConfigFileProcessor(super.args);

  @override
  String execute() {
    if (input == null) return '';
    final buffer = StringBuffer(input!);

    _removeMustacheComments(buffer);

    return buffer.toString();
  }

  /// region Private methods

  void _removeMustacheComments(StringBuffer buffer) {
    final replacement = buffer.toString().replaceAll('# {{/}}', '');
    buffer
      ..clear()
      ..write(replacement);
  }

  /// endregion
}
