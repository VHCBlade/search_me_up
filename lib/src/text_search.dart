/// Will see if the given [input] matches this function.
typedef SMUTextSearcher = bool Function(Iterable<String> input);

/// Provides an [SMUTextSearcher] that will search for the given [searchText]
typedef SMUTextSearcherProvider = SMUTextSearcher Function(String searchText);

/// Creates the corresponding [SMUTextSearcher] from the given [expression].
///
/// The returned function will check if any passed strings have a match with [expression], returning true if at least one input matches.
SMUTextSearcher generateTextSearcherFromRegExp(RegExp expression) =>
    (input) => input
        .map((e) => expression.hasMatch(e))
        .reduce((value, element) => value || element);

/// Output will check if any given input starts with the [searchText], case insensitive.
SMUTextSearcher frontTextSearcher(String searchText) {
  final expression =
      RegExp('^${RegExp.escape(searchText)}(.)*', caseSensitive: false);
  return generateTextSearcherFromRegExp(expression);
}

/// Output will check if any given input contains the [searchText], case insensitive.
SMUTextSearcher inlineTextSearcher(String searchText) {
  final expression =
      RegExp('.*${RegExp.escape(searchText)}.*', caseSensitive: false);
  return generateTextSearcherFromRegExp(expression);
}

/// Output will check if any given input contains the [searchText], with any amount of letters inserted within [searchText], case-insensitive.
SMUTextSearcher orderTextSearcher(String searchText) {
  final splitSearch = searchText
      .split('')
      .where((element) => element != ' ' && element != '-')
      .map(RegExp.escape);
  final searchValue =
      splitSearch.reduce((value, element) => '$value[^$element]*$element');
  final expression = RegExp('.*$searchValue.*', caseSensitive: false);
  return generateTextSearcherFromRegExp(expression);
}
