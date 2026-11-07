import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'built_in_catalog.dart';

/// Picks a fitting icon and category for an item the user typed, from the
/// words in its name (English and Dutch): "Cherry tomatoes", "kerstomaten"
/// and "tomatensaus" find tomatoes, tomatoes and pasta sauce.
///
/// The main noun comes last in both languages, so the match that ends
/// furthest to the right wins; Dutch compounds match on their ending
/// ("volkorenbrood" -> bread). Among matches ending at the same place the
/// longest wins ("pindakaas" is peanut butter, not cheese).
abstract final class ItemMatcher {
  /// The built-in item whose icon and category fit [name], or null.
  static BuiltInItem? match(String name) {
    final tokens = normalize(name).split(' ').where((t) => t.isNotEmpty);
    final words = tokens.toList();
    String? bestKey;
    var bestEnd = -1;
    var bestLength = 0;
    void consider(String key, int end, int length) {
      if (end > bestEnd || (end == bestEnd && length > bestLength)) {
        bestKey = key;
        bestEnd = end;
        bestLength = length;
      }
    }

    for (var end = 0; end < words.length; end++) {
      final word = words[end];
      // Whole words and phrases of up to three words ending here.
      for (var start = end; start >= 0 && start > end - 3; start--) {
        final phrase = words.sublist(start, end + 1).join(' ');
        final key = _index[phrase];
        if (key != null) consider(key, end, phrase.length);
      }
      // The ending of a compound word.
      for (final entry in _singleWords.entries) {
        if (word.length > entry.key.length && word.endsWith(entry.key)) {
          consider(entry.value, end, entry.key.length);
        }
      }
    }
    return bestKey == null ? null : _byKey[bestKey];
  }

  /// Lowercase, without accents or punctuation, single spaces.
  static String normalize(String text) {
    final lower = text.toLowerCase();
    final buffer = StringBuffer();
    for (final rune in lower.runes) {
      final char = String.fromCharCode(rune);
      buffer.write(_accents[char] ?? char);
    }
    return buffer.toString().replaceAll(RegExp('[^a-z0-9]+'), ' ').trim();
  }

  /// Gives own items without an icon (added before the matcher existed) the
  /// icon and category of a match, and updates the list items that use
  /// them. Items the matcher finds nothing for are left alone.
  static Future<void> backfill(Session session) async {
    final own = await CatalogItem.db.find(
      session,
      where: (t) =>
          t.householdId.notEquals(null) &
          t.iconKey.equals('') &
          t.category.equals(ShoppingCategory.other),
    );
    for (final item in own) {
      final guess = match(item.nameEn);
      if (guess == null) continue;
      await session.db.transaction((transaction) async {
        await CatalogItem.db.updateRow(
          session,
          item.copyWith(
            iconKey: guess.iconKey,
            category: guess.category,
            updatedAt: DateTime.now(),
          ),
          transaction: transaction,
        );
        final listItems = await ShoppingItem.db.find(
          session,
          where: (t) =>
              t.catalogItemId.equals(item.id) &
              t.iconKey.equals('') &
              t.category.equals(ShoppingCategory.other),
          transaction: transaction,
        );
        if (listItems.isEmpty) return;
        await ShoppingItem.db.update(
          session,
          [
            for (final listItem in listItems)
              listItem.copyWith(
                iconKey: guess.iconKey,
                category: guess.category,
                updatedAt: DateTime.now(),
              ),
          ],
          transaction: transaction,
        );
      });
    }
  }

  static final Map<String, BuiltInItem> _byKey = {
    for (final item in builtInItems) item.key: item,
  };

  /// Word or phrase -> built-in key.
  static final Map<String, String> _index = _buildIndex();

  /// The single words of [_index] that may end a compound word. Very short
  /// words ("ui", "ei") only match on their own.
  static final Map<String, String> _singleWords = {
    for (final entry in _index.entries)
      if (!entry.key.contains(' ') && entry.key.length >= 3)
        entry.key: entry.value,
  };

  static Map<String, String> _buildIndex() {
    final index = <String, String>{};
    void add(String words, String key) {
      final normal = normalize(words);
      if (normal.isNotEmpty) index.putIfAbsent(normal, () => key);
    }

    // Exact names first, so they win over synonyms of other items.
    for (final item in builtInItems) {
      add(item.nameEn, item.key);
      add(item.nameNl, item.key);
    }
    for (final MapEntry(:key, value: words) in _synonyms.entries) {
      for (final word in words) {
        add(word, key);
      }
    }
    // English singulars: "tomato", "cherry", "grape".
    for (final item in builtInItems) {
      final singular = _singular(normalize(item.nameEn));
      if (singular != null) add(singular, item.key);
    }
    return index;
  }

  static String? _singular(String plural) {
    if (plural.endsWith('ies')) {
      return '${plural.substring(0, plural.length - 3)}y';
    }
    if (plural.endsWith('oes')) return plural.substring(0, plural.length - 2);
    if (plural.endsWith('s') && !plural.endsWith('ss')) {
      return plural.substring(0, plural.length - 1);
    }
    return null;
  }

  static const _accents = {
    'à': 'a', 'á': 'a', 'â': 'a', 'ä': 'a', 'ç': 'c', 'è': 'e', 'é': 'e', //
    'ê': 'e', 'ë': 'e', 'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i', 'ñ': 'n', //
    'ò': 'o', 'ó': 'o', 'ô': 'o', 'ö': 'o', 'ù': 'u', 'ú': 'u', 'û': 'u', //
    'ü': 'u', "'": '',
  };

  /// Other words for built-in items, English and Dutch (Belgian and Dutch
  /// usage), singular where the plural is irregular.
  static const _synonyms = <String, List<String>>{
    'apples': ['appel'],
    'bananas': ['banaan'],
    'pears': ['peer'],
    'oranges': ['sinaasappel', 'mandarijn', 'mandarijnen', 'clementines'],
    'lemons': ['citroen'],
    'limes': ['limoen'],
    'grapes': ['druif'],
    'strawberries': ['aardbei'],
    'raspberries': ['framboos'],
    'blueberries': ['bosbessen'],
    'cherries': ['kers'],
    'tomatoes': ['tomaat'],
    'carrots': ['wortel', 'worteltjes'],
    'potatoes': ['aardappel', 'patatten', 'krieltjes'],
    'onions': ['ui', 'uitjes', 'sjalotten', 'shallots'],
    'garlic': ['knoflook'],
    'bell_peppers': ['paprikas', 'peppers'],
    'courgette': ['zucchini'],
    'mushrooms': ['champignon', 'paddenstoelen', 'oesterzwammen'],
    'lettuce': ['ijsbergsla', 'rucola', 'veldsla'],
    'salad_mix': ['salade'],
    'herbs': ['basilicum', 'peterselie', 'koriander', 'basil', 'parsley'],
    'bread': ['loaf', 'toast'],
    'rolls': ['broodjes', 'buns'],
    'cake': ['gebak'],
    'butter': ['margarine'],
    'cream': ['slagroom'],
    'cheese': ['gouda', 'cheddar', 'brie', 'camembert', 'emmentaler'],
    'yoghurt': ['yogurt'],
    'eggs': ['ei', 'egg'],
    'minced_meat': ['mince'],
    'sausages': ['worst', 'worstjes', 'chipolata'],
    'bacon': ['spekjes', 'lardons'],
    'salmon': ['zalm'],
    'white_fish': ['vis', 'fish', 'kabeljauw', 'cod'],
    'shrimp': ['garnaal', 'scampi', 'prawns'],
    'ham': ['hesp'],
    'fries': ['friet', 'patat'],
    'frozen_pizza': ['pizza'],
    'ice_cream': ['roomijs'],
    'pasta': [
      'spaghetti',
      'macaroni',
      'penne',
      'lasagne',
      'tagliatelle',
      'fusilli',
    ],
    'noodles': ['mie'],
    'rice': ['rijst'],
    'flour': ['bloem'],
    'sugar': ['suiker'],
    'sunflower_oil': ['olie', 'oil'],
    'vinegar': ['azijn'],
    'tomato_sauce': ['saus', 'sauce', 'passata'],
    'stock_cubes': ['bouillon', 'stock'],
    'beans': ['bonen'],
    'mayonnaise': ['mayo'],
    'mustard': ['mosterd'],
    'coffee': ['koffiebonen', 'coffee beans'],
    'tea': ['thee'],
    'jam': ['confituur'],
    'honey': ['honing'],
    'cereal': ['cornflakes', 'granola'],
    'chocolate_spread': ['choco'],
    'crisps': ['chips'],
    'chocolate': ['chocolade'],
    'biscuits': ['koekjes', 'koeken', 'koek', 'cookies'],
    'sweets': ['snoep', 'snoepjes', 'candy'],
    'soft_drinks': ['cola', 'limonade', 'soda'],
    'beer': ['bier', 'pils'],
    'wine': ['wijn'],
    'orange_juice': ['sap', 'juice'],
    'toilet_paper': ['papier', 'wc papier'],
    'dish_soap': ['afwasmiddel'],
    'laundry_detergent': ['wasverzachter', 'softener'],
    'cleaning_spray': ['reiniger', 'schoonmaakmiddel'],
    'sponges': ['spons'],
    'aluminium_foil': ['foil', 'folie', 'aluminium'],
    'batteries': ['batterij'],
    'light_bulbs': ['lamp'],
    'candles': ['kaars'],
    'toothpaste': ['tandpasta'],
    'deodorant': ['deo'],
    'soap': ['zeep'],
    'plasters': ['pleister'],
    'painkillers': ['paracetamol', 'ibuprofen'],
    'tissues': ['zakdoeken'],
    'nappies': ['luiers', 'diapers'],
  };
}
