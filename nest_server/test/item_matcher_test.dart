import 'package:nest_server/src/services/built_in_catalog.dart';
import 'package:nest_server/src/services/item_matcher.dart';
import 'package:test/test.dart';

void main() {
  String? key(String name) => ItemMatcher.match(name)?.key;

  test('built-in names match in both languages', () {
    expect(key('Milk'), 'milk');
    expect(key('melk'), 'milk');
    expect(key("Kiwi's"), 'kiwis');
    expect(key('Maïs'), 'sweetcorn');
  });

  test('English singulars and Dutch synonyms match', () {
    expect(key('tomato'), 'tomatoes');
    expect(key('cherry'), 'cherries');
    expect(key('tomaat'), 'tomatoes');
    expect(key('knoflook'), 'garlic');
  });

  test('the last word decides', () {
    expect(key('Cherry tomatoes on the vine'), 'cherry_tomatoes');
    expect(key('Roma tomatoes'), 'tomatoes');
    expect(key('tomato sauce'), 'tomato_sauce');
    expect(key('Organic whole milk'), 'milk');
    expect(key('Coffee beans'), 'coffee');
  });

  test('Dutch compounds match on their ending', () {
    expect(key('Trostomaten'), 'tomatoes');
    expect(key('Volkorenbrood'), 'bread');
    expect(key('Tomatensaus'), 'tomato_sauce');
    expect(key('Gemberbier'), 'beer');
    expect(key('Roomboter'), 'butter');
  });

  test('a longer match wins over a shorter one at the same place', () {
    expect(key('Pindakaas'), 'peanut_butter');
    expect(key('Tandpasta'), 'toothpaste');
    expect(key('Peanut butter'), 'peanut_butter');
    expect(key('Tin foil'), 'aluminium_foil');
  });

  test('very short words only match on their own', () {
    expect(key('ui'), 'onions');
    expect(key('Rode ui'), 'onions');
    expect(key('Bui'), isNull);
  });

  test('unknown names match nothing', () {
    expect(key('Secret stuff'), isNull);
    expect(key(''), isNull);
    expect(key('%'), isNull);
  });

  test('every synonym points to a built-in item', () {
    final keys = builtInItems.map((i) => i.key).toSet();
    for (final word in ['appel', 'hesp', 'foil', 'olie', 'zeep']) {
      expect(keys, contains(key(word)));
    }
  });

  test('normalize drops accents, case and punctuation', () {
    expect(ItemMatcher.normalize('  Crème-Fraîche!  '), 'creme fraiche');
  });
}
