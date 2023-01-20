class StringUtils {
  static String toPascalCase(String source) => source
      .toLowerCase()
      .replaceAll(RegExp('[^A-Za-z0-9]'), ' ')
      .split(' ')
      .where((word) => word.isNotEmpty)
      .fold('', (concatenation, word) => concatenation + capitalize(word));

  static String removeDiacritics({required String source}) {
    var withDiacritics = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDiacritics = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    return source.splitMapJoin('',
        onNonMatch: (char) =>
            char.isNotEmpty && withDiacritics.contains(char) ? withoutDiacritics[withDiacritics.indexOf(char)] : char);
  }

  static String capitalize(String source) => source[0].toUpperCase() + source.substring(1);
}
