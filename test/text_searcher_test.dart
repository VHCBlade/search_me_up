import 'package:search_me_up/src/text_search.dart';
import 'package:test/test.dart';

void main() {
  group('SMU Text Searcher', () {
    test('Front Text', frontText);
    test('Inline Text', inlineText);
    test('Order Text', orderText);
  });
}

void frontText() {
  final searcher = frontTextSearcher('MyEx');
  expect(searcher(['Myex']), true);
  expect(searcher({'MyLife', 'MyEx'}), true);
  expect(searcher({'', 'mYeX'}), true);
  expect(searcher({''}), false);
  expect(searcher(['MyLife', 'Great']), false);
  expect(searcher(['You are MyEx']), false);
  expect(searcher(['MyEx is great']), true);
  expect(searcher(['My Ex is great']), false);
  expect(searcher([' MyEx is great']), false);

  final specialChars = frontTextSearcher('.()[]<>');
  expect(specialChars(['.()[]<>']), true);
  expect(specialChars(['a()[]<>']), false);
}

void inlineText() {
  final searcher = inlineTextSearcher('MyEx');
  expect(searcher(['Myex']), true);
  expect(searcher({'MyLife', 'MyEx'}), true);
  expect(searcher({'', 'mYeX'}), true);
  expect(searcher({''}), false);
  expect(searcher(['MyLife', 'Great']), false);
  expect(searcher(['You are MyEx']), true);
  expect(searcher(['MyEx is great']), true);
  expect(searcher(['My Ex is great']), false);
  expect(searcher([' MyEx is great']), true);
  expect(searcher([' MyEx makes me happy MyEx', 'Great']), true);
  expect(searcher([' msylae', ' myex']), true);

  final specialChars = inlineTextSearcher('.()[]<>');
  expect(specialChars(['aefea.()[]<>aefafeasf']), true);
  expect(specialChars(['.a()[]<>']), false);
}

void orderText() {
  final searcher = orderTextSearcher('MyEx');
  expect(searcher(['M[^y]*y[^E]*E[^x]*x']), true);
  expect(searcher(['Myex']), true);
  expect(searcher({'MyLife', 'MyEx'}), true);
  expect(searcher({'', 'mYeX'}), true);
  expect(searcher({''}), false);
  expect(searcher(['MyLife', 'Great']), false);
  expect(searcher(['My You are Ex']), true);
  expect(searcher(['M y e x']), true);
  expect(searcher(['My x is great']), false);
  expect(searcher(['   Make play trouble xtrme']), true);
  expect(searcher([' MyEx makes me happy MyEx', 'Great']), true);
  expect(searcher([' msylae', ' myex']), true);

  final specialChars = orderTextSearcher('.()[]<>');
  expect(specialChars(['.()[]<>']), true);
  expect(specialChars(['.aefea(<>aefafe)as[f] < 3224df>']), true);
  expect(specialChars(['.a()[]<']), false);

  final ignoreSpaceBarAndDash = orderTextSearcher('Pull -up');
  expect(ignoreSpaceBarAndDash(['Pullup']), true);
  expect(ignoreSpaceBarAndDash(['Pull-up']), true);
  expect(ignoreSpaceBarAndDash(['Pull up']), true);
  expect(ignoreSpaceBarAndDash(['Push up']), false);
}
