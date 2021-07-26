import 'package:search_me_up/search_me_up.dart';
import 'package:tuple/tuple.dart';

/// This handles the search ranking logic, based on whatever [delegate] is given.
class SearchMeUp<T> {
  SearchMeUpDelegate<T> delegate;

  SearchMeUp(this.delegate);

  /// Performs a search on the [searchArea] using the given text. The type of search to be made is dictated by [delegate].
  ///
  /// The returned value returns the ranked version of the search result. Each entry in the list represents its own individual rank. The earlier the higher. Every item in the set in each entry has the same rank.
  ///
  /// If [limit] is specified and is greater than 0, the number of returned values will be no greater than [limit]
  List<Set<T>> rankedSearch(String text, Iterable<T> searchArea, {limit = 0}) {
    final logicList = delegate.generateSearchLogic(text);
    final hasLimit = limit > 0;

    final retVal = <Set<T>>[];
    for (final logic in logicList) {
      retVal.add({});
      searchArea.forEach((element) {
        // Check if the limit has been reached.
        if (hasLimit && limit < 1) {
          return;
        }
        // Check if the value has been evaluated already.
        final evaluated = retVal
            .map((sets) => sets.contains(element))
            .reduce((a, b) => a || b);

        if (evaluated) {
          return;
        }

        // Check if the search function is triggered.
        final search = logic.item1(element);
        if (!logic.item2(search)) {
          return;
        }
        retVal[retVal.length - 1].add(element);
        limit--;
      });
      if (hasLimit && limit < 0) {
        return retVal;
      }
    }
    return retVal;
  }
}

abstract class SearchMeUpDelegate<T> {
  /// Generates the search logic to be used by a [SearchMeUp].
  ///
  /// The order of the return value represents the ranking, the ones that come first are higher ranked.
  Iterable<Tuple2<SMUTextConverter<T>, SMUTextSearcher>> generateSearchLogic(
      String searchText);
}

/// Default implementation of [SearchMeUpDelegate]
///
/// This creates a simple ranking from the given [converters]s and [providers]s, simply returning all combinations of each converter and provider, using the order of the converter, and then the provider. ([converter1, converter2] and [provider1 and provider2] will lead to [<converter1 provider1>, <converter1 provider2>, <converter2, provider1>, <converter2, provider2>])
class DefaultSearchMeUpDelegate<T> implements SearchMeUpDelegate<T> {
  final List<SMUTextConverter<T>> converters;
  final List<SMUTextSearcherProvider> providers;

  /// [converters] and [providers] are combined to create the return value of [generateSearchLogic]. All combinations will be made, ordered first by the [converters], and then second the [providers] order.
  DefaultSearchMeUpDelegate({
    this.converters = const [defaultSMUTextConverter],
    this.providers = const [
      frontTextSearcher,
      inlineTextSearcher,
      orderTextSearcher
    ],
  });

  @override
  Iterable<Tuple2<SMUTextConverter<T>, SMUTextSearcher>> generateSearchLogic(
      String searchText) {
    final searchers = providers.map((element) => element(searchText));

    return converters
        .map((element) => searchers.map((value) => Tuple2(element, value)))
        .reduce((value, element) => value.followedBy(element));
  }
}
