/// StringBuffer class extensions
extension StringBufferExtensions on StringBuffer {
  /// Finds the index of the [n]th occurrence of the [pattern] with an optional
  /// [start] position.
  int nthIndexOf(String pattern, {int n = 1, int start = 0}) {
    final source = toString();
    if (!source.contains(pattern)) return -1;

    var subIndex = -1;
    while (n > 0) {
      subIndex = source.indexOf(pattern, subIndex < 0 ? start : subIndex + 1);
      n--;
    }

    return subIndex;
  }

  /// Inserts [content] at a given non-negative [index]. If the [index] is out
  /// of bounds (greater than the content length) it will be added at the end of
  /// the buffer.
  void insertAt(int index, String content) {
    assert(index >= 0, 'Position index cannot be null');
    final source = toString();
    final pos = index >= source.length ? source.length - 1 : index;
    clear();
    write(source.replaceRange(pos, pos, content));
  }

  /// Inserts [content] at the beginning of the first found [pattern] starting
  /// from the [start] index. Returns `true` if content was successfully
  /// inserted, `false` otherwise.
  bool insertBefore(String pattern, String content, [int start = 0]) {
    final source = toString();
    final pos = source.indexOf(pattern, start);
    if (pos < 0) return false;
    insertAt(pos, content);
    return true;
  }

  /// Inserts [content] at the end of the first found [pattern] starting
  /// from the [start] index. Returns `true` if content was successfully
  /// inserted, `false` otherwise.
  bool insertAfter(String pattern, String content, [int start = 0]) {
    final source = toString();
    final pos = source.indexOf(pattern, start);
    if (pos < 0) return false;
    insertAt(pos + pattern.length, content);
    return true;
  }

  /// Replaces content in range from [start] to [end] with [content]
  void replaceRange(int start, int? end, String content) {
    final source = toString();
    clear();
    write(source.replaceRange(start, end, content));
  }

  /// Returns a tuple (start,end) with indices marking the start and end
  /// position of the last line in a regular [section] in a gradle file. The
  /// [section] starts with a name and has no nested sections inside its curly
  /// brackets. The section should contain at least one line ending in a new
  /// line character ('\n').
  ///
  /// If section does not exist (-1,-1) will be returned.
  ///
  /// Example:
  ///
  /// Suppose a file has the following contents:
  ///
  /// ```
  /// sectionName {
  ///   variable1Name variable2Type variable1Value
  ///   variable2Name variable2Type variable2Value
  /// }
  /// ```
  ///
  /// By calling the method with the value 'sectionName' the result will be
  /// the following:
  ///
  /// getGradleSectionLastLineRange('sectionName') => (105, 106)
  ///
  /// And by checking, we can confirm that the last line begins after the
  /// `variable2Value` line break (has index 105) and ends right before the
  /// closing curly bracket (has index 106).
  ///
  (int, int) getGradleSectionLastLineRange(String section) {
    final sectionStartPos = nthIndexOf(section);
    if (sectionStartPos < 0) return (-1, -1);
    final end = nthIndexOf('}', start: sectionStartPos);
    final start = toString().lastIndexOf('\n', end);
    return (start, end);
  }
}
