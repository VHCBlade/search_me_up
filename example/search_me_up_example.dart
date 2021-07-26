import 'package:search_me_up/search_me_up.dart';

void main() {
  final searchDelegate =
      DefaultSearchMeUpDelegate(); // This is the default Search Delegate, you can implement your own or pass arguments to change the behaviour
  final searchMeUp = SearchMeUp(
      searchDelegate); // This is the search engine, whose behaviour is modified by the searchDelegate

  // Default ranking is 1. Starts with search string, 2. Has search string somewhere, 3. Has the order given by the string somewhere
  print(searchMeUp.rankedSearch('Example', EXAMPLE_DATA));
  print(searchMeUp.rankedSearch('Do', EXAMPLE_DATA));
}

const EXAMPLE_DATA = [
  'Does not pass 1',
  'Example Data o',
  'This is an example',
  'Does not pass 2',
  'Example 2',
  'This is example 2',
  'Does not pass 3',
  'Example 3',
  'E s x s a s m s p s l s e',
  'pass this does not',
];
