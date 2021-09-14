import 'package:search_me_up/search_me_up.dart';

class SortedSearchList<T, S> {
  final List<S> list = [];
  Comparator<T> comparator;
  S Function(T) converter;

  SortedSearchList({required this.comparator, required this.converter});

  /// Removes the values in the [list] and generates a new one in the correct order based on [comparator] with the given [values].
  ///
  /// If [searchTerm] is provided, then a [rankedSearch] with the given [searchMeUp] is automatically triggered. The order will be based on the ranking first, and then the order based on [comparator]
  void generateSearchList({
    String? searchTerm,
    required Iterable<T> values,
    required SearchMeUp<T> searchMeUp,
  }) {
    list.clear();
    if (searchTerm == null || searchTerm.isEmpty) {
      sortThenAdd(values);
      return;
    }

    final search = searchMeUp.rankedSearch(searchTerm, values);
    search.forEach(sortThenAdd);
  }

  /// Will sort the [items] and then add them to the [list]
  void sortThenAdd(Iterable<T> items) {
    final sortedList = items.toList()..sort(comparator);
    list.addAll(sortedList.map(converter));
  }
}
