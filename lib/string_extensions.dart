final _primitives = ['int', 'double', 'Null', 'String', 'bool'];
final _collections = ['List', 'Map', 'Set'];

extension StringExtensions on String {
  /// region Universal String extension

  /// Returns the index of the [n]th occurence of a [pattern]
  /// starting from the end of the string.
  ///
  /// Returns -1 if the nth occurence of the string doesn't exist
  int nthIndexReverse(String pattern, int n) {
    int index = this.length;
    try {
      int i = 0;
      while (i < n) {
        index = this.lastIndexOf(pattern, index - 1);
        i++;
      }
    } catch (_) {
      index = -1;
    }
    return index;
  }

  /// Removes a character with a given index from the string.
  /// If the index is outside the range, nothing is removed.
  String removeCharacterAt(int index) {
    if (index < 0 || index >= this.length) return this;
    return '${this.substring(0, index)}${this.substring(index + 1)}';
  }

  /// Counts the number of appearances of a pattern
  /// within the range of two indices.
  int count(String pattern, [int startIndex = 0, int endIndex]) {
    if (endIndex == null) endIndex = this.length - 1;
    final substr = this.substring(startIndex, endIndex);

    int index = 0;
    int count = 0;
    while (index != -1) {
      index = substr.indexOf(pattern, index);
      if (index != -1) {
        count++;
        index += pattern.length;
      }
    }
    return count;
  }

  /// endregion

  ///region Generator specific extensions

  /// Searches and removes spacing between primitive type names
  /// and the opening brackets so it can be parsed correctly.
  String _removeSpacingBetweenPrimitiveAndBracket() {
    var str = this;
    _primitives.forEach((prim) {
      final origPrim = prim;
      prim += ' (';
      if (!str.contains(prim)) return;

      int index = str.indexOf(prim);

      while (index != -1) {
        str = str.replaceFirst(prim, '$origPrim(');
        index = str.indexOf(prim);
      }
    });

    return str;
  }

  /// Searches and removes default constructors of primitive types
  /// returning a string that is correctly cleared
  String _removePrimitiveConstructors() {
    var str = this._removeSpacingBetweenPrimitiveAndBracket();
    _primitives.forEach((prim) {
      prim += '(';
      if (!str.contains(prim)) return;

      int ind = str.indexOf(prim);
      while (ind != -1) {
        int entered = str.count(
            '(', 0, ind); // Number of brackets entered before the inner one

        str = str.removeCharacterAt(str.nthIndexReverse(')', entered + 1));
        str = str.replaceFirst(prim, '', ind);

        ind = str.indexOf(prim);
      }
    });

    return str;
  }

  /// Searches and removes unnecessary parts
  /// of a constant expression collection
  String _removeCollectionConstructor() {
    var str = this;

    _collections.forEach((coll) {
      coll += '<';
      if (!str.contains(coll)) return;

      int ind = str.indexOf(coll);
      while (ind != -1) {
        int entered = str.count('(', 0, ind);
        int ind2 = str.indexOf('>', ind);
        // There may be an empty space, so check for it
        if (str[ind2 + 1] == ' ') ind2++;

        str = str.replaceRange(ind, ind2 + 2, '');
        str = str.removeCharacterAt(str.nthIndexReverse(')', entered + 1));

        ind = str.indexOf(coll);
      }
    });

    return str;
  }

  /// Converts a string to a valid generated string
  String convertToValidString() {
    return this
        ._removeCollectionConstructor()
        ._removePrimitiveConstructors()
        .replaceAll('=', ':');
  }

  ///endregion

}
