import 'package:search_me_up/search_me_up.dart';
import 'package:test/test.dart';

import 'sample_data.dart';

void main() {
  group('Search Me Up', () {
    test('Basic', basicCheck);
    test('Converter', converterCheck);
  });
}

void basicCheck() {
  final smu = SearchMeUp(DefaultSearchMeUpDelegate());
  final ranking11 = smu.rankedSearch('test', TEST_DATA_1);
  final ranking12 = smu.rankedSearch('ismy', TEST_DATA_1);
  final ranking13 = smu.rankedSearch('test', TEST_DATA_1, limit: 5);
  final ranking14 = smu.rankedSearch('ismy', TEST_DATA_1, limit: 5);

  expect(
      ranking11[0], {'Test', 'TestData', 'Testing shamy', 'testing ISMY life'});
  expect(ranking11[1],
      {'This is my Test', 'Where ismy test', 'Daily Tests make me happy'});
  expect(ranking11[2], {'T e s t', 'Hooray for things that are made easyt'});

  expect(ranking12[0], {'ismy'});
  expect(ranking12[1], {'Cool ismy', 'Where ismy test', 'testing ISMY life'});
  expect(ranking12[2], {
    'This is my Test',
    'Why is my nman',
    'Testing shamy',
    'Daily Tests make me happy',
    'Hooray for things that are made easy',
    'Hooray for things that are made easyt'
  });

  expect(
      ranking13[0], {'Test', 'TestData', 'Testing shamy', 'testing ISMY life'});
  expect(ranking13[1], {'This is my Test'});
  expect(ranking13[2], <String>{});

  expect(ranking14[0], {'ismy'});
  expect(ranking14[1], {'Cool ismy', 'Where ismy test', 'testing ISMY life'});
  expect(ranking14[2], {'This is my Test'});
}

class TestClass {
  final String value;

  TestClass(this.value);
}

void converterCheck() {
  final smu = SearchMeUp<TestClass>(DefaultSearchMeUpDelegate(converters: [
    (element) => [element.value]
  ]));
  final ranking =
      smu.rankedSearch('li', TEST_DATA_1.map((val) => TestClass(val)).toList());

  expect(ranking[1].map((val) => val.value).toSet(), {'testing ISMY life'});
  expect(ranking[2].map((val) => val.value).toSet(), {'Cool ismy'});
}
