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
    expect(key('Organic whole milk'), 'whole_milk');
    expect(key('Organic milk'), 'milk');
    expect(key('Coffee beans'), 'coffee_beans');
    expect(key('Ground coffee'), 'ground_coffee');
  });

  test('Dutch compounds match on their ending', () {
    expect(key('Trostomaten'), 'tomatoes');
    expect(key('Volkorenbrood'), 'wholemeal_bread');
    expect(key('Maisbrood'), 'bread');
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
    expect(key('Rode ui'), 'red_onions');
    expect(key('Gele ui'), 'onions');
    expect(key('Bui'), isNull);
  });

  test('the extended catalog finds specific items before general ones', () {
    expect(key('Witloof'), 'chicory');
    expect(key('Bloemkool'), 'cauliflower');
    expect(key('Spitskool'), 'white_cabbage');
    expect(key('Jonge kaas'), 'young_cheese');
    expect(key('Geraspte gouda'), 'gouda');
    expect(key('Filet américain'), 'filet_americain');
    expect(key('Mosselen'), 'mussels');
    expect(key('Grijze garnalen'), 'grey_shrimp');
    expect(key('Rode wijn'), 'red_wine');
    expect(key('Kriek'), 'special_beers');
    expect(key('Jupiler'), 'lager');
    expect(key('Speculoospasta'), 'speculoos_spread');
    expect(key('Speculoos'), 'speculoos');
    expect(key('Hagelslag'), 'chocolate_sprinkles');
    expect(key('Frikandellen'), 'frozen_snacks');
    expect(key('Rucola'), 'rocket');
    expect(key('Basilicum'), 'basil');
    expect(key('Spaghetti'), 'spaghetti');
    expect(key('Mandarijn'), 'mandarins');
    expect(key('Wasverzachter'), 'fabric_softener');
    expect(key('PMD-zakken'), 'pmd_bags');
  });

  test('extended compounds still pick the right noun', () {
    expect(key('Volkorenspaghetti'), 'spaghetti');
    expect(key('Rijstpap'), 'rice_pudding');
    expect(key('Griesmeelpap'), 'porridge');
    expect(key('Hoestsiroop'), 'cough_syrup');
    expect(key('Tomatenpuree'), 'tomato_puree');
    expect(key('Zonnecrème'), 'sun_cream');
    expect(key('Kipnuggets'), 'chicken_nuggets');
    expect(key('Kippenboutjes'), 'chicken_drumsticks');
    expect(key('Bruinbrood'), 'brown_bread');
    expect(key('Notenbrood'), 'bread');
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

  test('every built-in name finds its own item', () {
    for (final item in builtInItems) {
      expect(key(item.nameEn), item.key, reason: item.nameEn);
      expect(key(item.nameNl), item.key, reason: item.nameNl);
    }
  });

  test('normalize drops accents, case and punctuation', () {
    expect(ItemMatcher.normalize('  Crème-Fraîche!  '), 'creme fraiche');
  });
}
