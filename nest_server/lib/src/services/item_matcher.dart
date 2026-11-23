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
    'oranges': ['sinaasappel'],
    'lemons': ['citroen'],
    'grapes': ['druif'],
    'strawberries': ['aardbei'],
    'cherries': ['kers'],
    'tomatoes': ['tomaat', 'tomaatjes'],
    'carrots': ['wortel', 'worteltjes'],
    'potatoes': ['aardappel', 'patatten', 'krieltjes'],
    'onions': ['ui', 'uitjes'],
    'garlic': ['knoflook'],
    'bell_peppers': ['paprikas', 'peppers'],
    'courgette': ['zucchini'],
    'mushrooms': ['champignon', 'paddenstoelen', 'oesterzwammen'],
    'salad_mix': ['salade'],
    'limes': ['limoen'],
    'blueberries': ['bosbessen'],
    'raspberries': ['framboos'],
    'bread': ['loaf', 'toast'],
    'rolls': ['broodjes', 'buns'],
    'cake': ['gebak'],
    'eggs': ['ei', 'egg'],
    'yoghurt': ['yogurt'],
    'minced_meat': ['mince'],
    'sausages': ['worst', 'worstjes'],
    'bacon': ['spekjes'],
    'salmon': ['zalm', 'zalmfilet'],
    'white_fish': ['vis', 'fish'],
    'shrimp': ['garnaal', 'prawns'],
    'ham': ['hesp'],
    'fries': ['friet', 'patat', 'frietjes', 'ovenfrietjes'],
    'frozen_pizza': ['pizza'],
    'rice': ['rijst'],
    'flour': ['bloem'],
    'sugar': ['suiker'],
    'vinegar': ['azijn'],
    'tomato_sauce': ['saus', 'sauce'],
    'stock_cubes': ['bouillon', 'stock'],
    'beans': ['bonen'],
    'mayonnaise': ['mayo'],
    'mustard': ['mosterd'],
    'noodles': ['mie', 'bami'],
    'sunflower_oil': ['olie', 'oil'],
    'tea': ['thee'],
    'jam': ['confituur'],
    'chocolate_spread': ['choco'],
    'honey': ['honing'],
    'crisps': ['chips'],
    'chocolate': ['chocolade'],
    'biscuits': ['koekjes', 'koeken', 'koek', 'cookies'],
    'sweets': ['snoep', 'snoepjes', 'candy'],
    'orange_juice': [],
    'soft_drinks': ['soda'],
    'beer': ['bier'],
    'wine': ['wijn'],
    'toilet_paper': ['papier', 'wc papier'],
    'dish_soap': ['afwasmiddel'],
    'cleaning_spray': ['reiniger', 'schoonmaakmiddel'],
    'sponges': ['spons'],
    'aluminium_foil': ['foil', 'folie', 'aluminium'],
    'batteries': ['batterij'],
    'light_bulbs': ['lamp'],
    'candles': ['kaars'],
    'toothpaste': ['tandpasta'],
    'soap': ['zeep'],
    'deodorant': ['deo'],
    'plasters': ['pleister'],
    'painkillers': ['paracetamol', 'ibuprofen'],
    'tissues': ['zakdoeken'],
    'nappies': ['luiers', 'diapers'],
    'mandarins': ['mandarijn', 'clementines', 'clementine', 'tangerines'],
    'grapefruit': ['grapefruits', 'pompelmoezen'],
    'peaches': ['perzik', 'nectarine', 'nectarines'],
    'plums': ['pruim'],
    'apricots': ['abrikoos'],
    'melon': ['meloenen', 'cantaloupe', 'galia'],
    'mango': ['mangos', 'mangoes'],
    'passion_fruit': ['passievrucht', 'maracuja'],
    'figs': ['vijg'],
    'dates': ['dadel', 'medjool'],
    'blackberries': ['braam'],
    'redcurrants': ['aalbessen'],
    'lychees': ['lychee'],
    'brussels_sprouts': ['spruiten'],
    'white_cabbage': [
      'kool',
      'cabbage',
      'wittekool',
      'spitskool',
      'pointed cabbage',
    ],
    'red_cabbage': ['rodekool'],
    'chicory': ['witlof', 'endive', 'belgian endive'],
    'rocket': ['arugula'],
    'asparagus': ['asperge', 'witte asperges', 'groene asperges'],
    'aubergine': ['eggplant', 'aubergines'],
    'celery': ['selderij', 'bleekselder', 'celery sticks'],
    'celeriac': ['knolselderij'],
    'beetroot': ['rode bieten', 'bietjes', 'beets'],
    'radishes': ['radijs'],
    'turnips': ['koolraap', 'rapen'],
    'pumpkin': ['butternut', 'squash', 'pompoenen'],
    'peas': ['erwtjes', 'doperwten', 'petits pois'],
    'mangetout': ['sugar snaps', 'snow peas'],
    'corn_on_the_cob': ['maiskolf'],
    'chilli_peppers': [
      'chili',
      'chilis',
      'rode peper',
      'spaanse peper',
      'jalapenos',
    ],
    'ginger': ['verse gember'],
    'red_onions': ['rode ui'],
    'shallots': ['sjalot'],
    'bean_sprouts': ['sojascheuten'],
    'cress': ['waterkers', 'watercress'],
    'coriander': ['cilantro'],
    'mint': ['verse munt'],
    'soup_vegetables': ['soepgroente'],
    'stir_fry_vegetables': ['wokgroente', 'roerbakgroenten'],
    'precut_vegetables': ['voorgesneden groenten'],
    'olives': ['olijf'],
    'white_bread': ['witbrood'],
    'brown_bread': ['bruinbrood', 'grijs brood'],
    'sourdough': ['zuurdesembrood', 'desem'],
    'pita': ['pita', 'pitabrood'],
    'naan': ['naan'],
    'pizza_dough': ['pizzabodem'],
    'shortcrust_pastry': ['taartdeeg', 'deeg'],
    'sandwiches': ['zachte broodjes', 'sandwichs'],
    'chocolate_croissants': ['pain au chocolat', 'koeken met chocolade'],
    'raisin_bread': [
      'krentenbrood',
      'rozijnenbroodjes',
      'suikerbrood',
      'craquelin',
    ],
    'crackers': ['cracotten', 'cracottes'],
    'pancakes': ['pannenkoek'],
    'waffles': ['wafel', 'luikse wafels', 'brusselse wafels'],
    'pie': ['vlaai', 'appeltaart', 'rijsttaart'],
    'breadcrumbs': ['broodkruimels'],
    'semi_skimmed_milk': ['halfvol'],
    'soy_milk': ['sojadrink', 'soja drink'],
    'almond_milk': ['amandeldrink'],
    'greek_yoghurt': ['greek yogurt'],
    'fruit_yoghurt': ['fruit yogurt'],
    'drinking_yoghurt': ['yakult', 'actimel'],
    'custard': ['vanillevla', 'chocoladevla'],
    'chocolate_mousse': ['mousse'],
    'cream_cheese': ['philadelphia', 'roomkaas', 'verse kaas'],
    'creme_fraiche': ['zure room', 'sour cream'],
    'whipped_cream': ['spuitbus slagroom'],
    'cooking_cream': ['culinaire room'],
    'margarine': ['bakboter', 'halvarine', 'minarine'],
    'dairy_free_yoghurt': ['soja yoghurt', 'alpro'],
    'free_range_eggs': ['vrije uitloop eieren', 'bio eieren'],
    'chicken_drumsticks': ['drumsticks', 'kippenbouten', 'kippenpootjes'],
    'chicken_wings': ['vleugeltjes', 'wings'],
    'whole_chicken': ['braadkip', 'soepkip'],
    'turkey': ['kalkoenfilet'],
    'pork_chops': ['kotelet', 'koteletten', 'karbonade'],
    'pork_tenderloin': ['varkenshaas'],
    'pork_belly': ['spekreepjes'],
    'spare_ribs': ['ribbetjes', 'ribs'],
    'beef_stew': ['runderstoofvlees', 'carbonades'],
    'roast_beef': ['gebraad'],
    'sirloin_steak': ['entrecôte', 'ribeye'],
    'fillet_steak': ['ossenhaas'],
    'veal': ['kalfsgehakt'],
    'lamb': ['lamskoteletten', 'lamsbout', 'lamb chops'],
    'mixed_mince': ['half om half'],
    'meatballs': ['balletjes', 'gehaktbal', 'boulettes'],
    'chicken_nuggets': ['nuggets'],
    'schnitzel': ['cordon bleu', 'escalope'],
    'bratwurst': ['braadworsten', 'bbq worsten'],
    'chipolata': ['chipolatas'],
    'hotdogs': ['knakworst', 'frankfurters', 'hotdog worstjes'],
    'bacon_strips': ['baconreepjes'],
    'diced_bacon': ['lardons'],
    'game': ['hert', 'everzwijn', 'venison'],
    'plaice': ['sole'],
    'tuna_steak': ['verse tonijn'],
    'herring': ['maatjesharing'],
    'fish_fingers': ['fishsticks', 'vissticks'],
    'mussels': ['mossel'],
    'grey_shrimp': ['grijze garnaal'],
    'king_prawns': ['scampi', 'gamba', 'gambas'],
    'squid': ['calamares', 'calamari', 'octopus'],
    'crab_sticks': ['krabsticks'],
    'vegetarian_mince': ['vegagehakt', 'veggie mince', 'plantaardig gehakt'],
    'veggie_burgers': ['veggieburgers', 'groenteburgers'],
    'seitan': ['quorn'],
    'young_cheese': ['jong belegen'],
    'mature_cheese': ['belegen kaas', 'extra belegen'],
    'cheese_slices': ['sneetjes kaas', 'kaasplakjes', 'plakjes kaas'],
    'emmental': ['emmentaler kaas'],
    'goats_cheese': ['chevre'],
    'blue_cheese': ['roquefort', 'gorgonzola'],
    'gruyere': ['comte', 'comté'],
    'abbey_cheese': ['passendale', 'maredsous', 'chimay kaas'],
    'halloumi': ['grillkaas'],
    'raclette_cheese': ['raclette'],
    'fondue_cheese': ['fondue'],
    'cooked_ham': ['gekookte ham', 'beenham'],
    'cured_ham': [
      'rauwe ham',
      'ardeense ham',
      'prosciutto',
      'parmaham',
      'serranoham',
    ],
    'chicken_slices': ['kippenwit', 'gerookte kip'],
    'pate': ['pastei', 'leverpastei', 'boerenpaté'],
    'filet_americain': ['prepare', 'préparé', 'americain', 'martino'],
    'smoked_beef': ['rosbief beleg', 'pastrami'],
    'mortadella': ['bologna', 'boulogne'],
    'sandwich_spread': ['sandwichspread', 'smeerbeleg'],
    'chicken_curry_salad': ['kipcurry', 'kipsalade'],
    'tapenade': ['pesto rosso'],
    'dips': ['dip', 'tzatziki', 'guacamole'],
    'fresh_pasta': ['tortellini', 'ravioli', 'gnocchi'],
    'ready_meals': [
      'kant en klaar maaltijd',
      'kant-en-klaarmaaltijd',
      'traiteur',
      'ovenschotel',
    ],
    'spring_rolls': ['loempia', 'loempias'],
    'frozen_berries': ['rood fruit', 'diepvries fruit'],
    'croquettes': ['aardappelkroketten', 'kroket', 'bitterballen'],
    'potato_wedges': ['wedges', 'rösti', 'rosti'],
    'frozen_snacks': [
      'frikandellen',
      'frikandel',
      'bicky',
      'mexicano',
      'kaaskroketten',
      'garnaalkroketten',
      'curryworst',
    ],
    'frozen_bread': ['afbakbrood', 'afbak'],
    'ice_lollies': ['ijsjes', 'raketjes', 'magnum', 'ijslollys'],
    'ice_cream_tub': ['potje ijs', 'sorbet'],
    'macaroni': ['hamburgermacaroni', 'elleboogjes'],
    'lasagne_sheets': ['lasagne'],
    'basmati_rice': ['basmati', 'jasmijnrijst', 'jasmine rice'],
    'risotto_rice': ['arborio'],
    'brown_rice': ['volkorenrijst'],
    'oats': ['oats', 'havervlokken'],
    'lentils': ['linze', 'rode linzen'],
    'kidney_beans': ['rode bonen'],
    'baked_beans': ['witte boontjes'],
    'canned_vegetables': ['conserven', 'erwtjes en worteltjes'],
    'canned_fruit': ['fruitcocktail', 'perziken op siroop'],
    'sardines': ['sardientjes', 'makreel in blik'],
    'pickles': ['augurk', 'pickles', 'zilveruitjes'],
    'tomato_puree': ['tomatenconcentraat', 'tomato paste'],
    'passata': ['gezeefde tomaten'],
    'soy_sauce': ['ketjap', 'kecap'],
    'hot_sauce': ['sriracha', 'tabasco', 'sambal'],
    'bbq_sauce': ['bbq saus'],
    'andalouse': ['andalouse', 'samurai', 'samuraisaus', 'bicky saus'],
    'tartare_sauce': ['tartaar'],
    'bearnaise': ['bearnaise'],
    'gravy': ['bruine saus', 'sausbinder', 'jus de viande'],
    'pepper_sauce': ['champignonsaus'],
    'salad_dressing': ['dressing', 'vinaigrette'],
    'balsamic_vinegar': ['balsamico'],
    'frying_oil': ['frituurolie', 'ossewit', 'blanc de boeuf'],
    'liquid_margarine': ['bak en braad'],
    'brown_sugar': ['kandijsuiker', 'cassonade'],
    'icing_sugar': ['bloemsuiker'],
    'sweetener': ['stevia', 'canderel', 'zoetjes'],
    'self_raising_flour': ['zelfrijzend bakmeel'],
    'cornflour': ['maizena', 'cornstarch'],
    'yeast': ['droge gist'],
    'vanilla_sugar': ['vanille', 'vanilla'],
    'cocoa_powder': ['cacao'],
    'baking_chocolate': ['fondant chocolade', 'chocoladedruppels'],
    'sprinkles': ['muisjes', 'discodip'],
    'gelatine': ['gelatineblaadjes'],
    'almonds': ['amandel'],
    'seeds': [
      'zonnebloempitten',
      'pompoenpitten',
      'lijnzaad',
      'chiazaad',
      'sesamzaad',
    ],
    'raisins': ['krenten', 'rozijn'],
    'dried_fruit': ['gedroogde abrikozen', 'pruimen gedroogd'],
    'curry_powder': ['kerrie'],
    'nutmeg': ['muskaat'],
    'oregano': [
      'italiaanse kruiden',
      'provencaalse kruiden',
      'herbes de provence',
    ],
    'bay_leaves': ['laurier'],
    'chilli_flakes': ['cayennepeper', 'cayenne'],
    'seasoning_mix': ['kruidenmengeling', 'taco kruiden', 'gyros kruiden'],
    'tortilla_chips': ['nachos', 'nacho chips'],
    'tortillas': ['tortilla', 'taco shells', 'tacos'],
    'rice_noodles': ['vermicelli'],
    'instant_noodles': ['ramen', 'cup noodles'],
    'instant_soup': ['soep in zakje', 'cup a soup'],
    'mashed_potato_mix': ['puree', 'aardappelpuree', 'stoemp'],
    'syrup': ['stroop', 'luikse siroop', 'ahornsiroop', 'maple syrup'],
    'speculoos_spread': ['speculoospasta', 'speculoos pasta', 'lotus pasta'],
    'hazelnut_spread': ['nutella'],
    'chocolate_sprinkles': ['chocoladehagel', 'chocolate flakes', 'vlokken'],
    'granola': ['krokante muesli', 'crunchy'],
    'ground_coffee': ['filterkoffie'],
    'coffee_pods': ['capsules', 'pads', 'koffiepads', 'nespresso', 'senseo'],
    'decaf': ['deca', 'decafe'],
    'herbal_tea': ['muntthee', 'kamillethee', 'rooibos'],
    'hot_chocolate': ['cacaodrank', 'chocolademelk poeder'],
    'coffee_creamer': ['koffieroom', 'creamer'],
    'crispbread': ['knackebrood'],
    'rusks': ['beschuit'],
    'speculoos': ['speculaas', 'lotus'],
    'gingerbread': ['ontbijtkoek'],
    'stroopwafels': ['stroopwafel'],
    'chocolate_bars': [
      'reep',
      'repen',
      'mars',
      'twix',
      'snickers',
      'kitkat',
      'leo',
    ],
    'pralines': ['bonbons', 'chocolates'],
    'pretzels': ['zoutjes', 'tuc', 'apero koekjes', 'borrelnootjes'],
    'salted_nuts': [
      'cocktailnootjes',
      "pinda's",
      'pindas',
      'peanuts',
      'apero nootjes',
    ],
    'cereal_bars': [
      'mueslirepen',
      'granolarepen',
      'proteïnerepen',
      'protein bars',
    ],
    'gummies': ['winegums', 'zure snoepjes', 'haribo', 'beertjes'],
    'liquorice': ['zoethout'],
    'marshmallows': ['spekjes snoep'],
    'mints': ['pepermunt', 'muntjes'],
    'sponge_fingers': ['boudoirs', 'boudoirkoekjes'],
    'apple_sauce': ['compote', 'appelcompote'],
    'fruit_pouches': ['knijpfruit'],
    'still_water': ['spa blauw'],
    'cola': ['coca cola', 'cola zero', 'pepsi'],
    'lemonade': ['fanta', 'sprite', '7up', 'citroenlimonade'],
    'tonic': ['tonic water', 'bitter lemon', 'schweppes'],
    'energy_drinks': ['red bull', 'monster'],
    'sports_drinks': ['aquarius', 'isostar', 'powerade'],
    'fruit_juice': [
      'multifruitsap',
      'multivitaminesap',
      'ananassap',
      'sap',
      'juice',
      'druivensap',
    ],
    'smoothies': ['smoothie'],
    'cordial': ['ranja', 'diksap', 'grenadine'],
    'lager': ['jupiler', 'stella', 'maes', 'primus', 'cristal'],
    'special_beers': [
      'trappist',
      'tripel',
      'dubbel',
      'duvel',
      'westmalle',
      'leffe',
      'kriek',
      'geuze',
      'gueuze',
      'witbier',
      'hoegaarden',
    ],
    'alcohol_free_beer': ['alcoholvrij'],
    'rose_wine': ['rosé', 'rose'],
    'champagne': ['prosecco', 'crémant', 'cremant'],
    'port': ['port wine', 'sherry', 'martini'],
    'spirits': [
      'vodka',
      'whisky',
      'whiskey',
      'rum',
      'gin',
      'jenever',
      'cognac',
      'likeur',
      'liqueur',
      'aperol',
      'pastis',
    ],
    'pmd_bags': ['pmd', 'blauwe zakken'],
    'compost_bags': ['gft zakken', 'gft'],
    'cling_film': ['vershoudfolie'],
    'baking_paper': ['ovenpapier'],
    'freezer_bags': ['boterhamzakjes', 'ziplock', 'sandwich bags'],
    'lunch_boxes': ['boterhamdoos', 'lunchbox'],
    'napkins': ['servetjes'],
    'paper_plates': ['wegwerpbekers', 'plastic bekers'],
    'fabric_softener': ['softener'],
    'stain_remover': ['vanish'],
    'bleach': ['javel', 'eau de javel'],
    'toilet_cleaner': ['wc eend', 'wc blokjes', 'toiletblokjes'],
    'glass_cleaner': ['ruitenreiniger'],
    'floor_cleaner': ['dettol', 'mr proper', 'dreft'],
    'descaler': ['ontkalkingsmiddel', 'kalkaanslag'],
    'dishwasher_salt': ['glansspoelmiddel', 'spoelglans', 'rinse aid'],
    'cleaning_cloths': ['vaatdoek', 'vaatdoeken', 'microvezeldoek', 'dweil'],
    'rubber_gloves': ['afwashandschoenen'],
    'air_freshener': ['febreze', 'geurkaars'],
    'matches': ['aansteker', 'lighter'],
    'charcoal': ['bbq kolen', 'aanmaakblokjes', 'firelighters'],
    'tealights': ['waxinelichtjes'],
    'plants': ['plant', 'kamerplant'],
    'insect_spray': ['muggenspray', 'muggenstekker'],
    'gifts': ['cadeautje', 'kado', 'present'],
    'wrapping_paper': ['cadeaupapier'],
    'party_supplies': ['ballonnen', 'slingers', 'balloons'],
    'greeting_cards': ['kaartje', 'verjaardagskaart', 'kaart'],
    'stamps': ['postzegel'],
    'stationery': ['pennen', 'balpennen', 'potloden', 'stiften'],
    'notebooks': ['schrift', 'notitieboek'],
    'school_supplies': ['schoolspullen', 'kaftpapier'],
    'tape': ['kleefband', 'ducttape'],
    'glue': ['plakstift'],
    'newspaper': ['tijdschrift', 'magazine'],
    'extension_lead': ['stekkerdoos'],
    'chargers': ['usb kabel', 'lader'],
    'paint': ['kwast'],
    'kitchen_utensils': ['bestek'],
    'conditioner': ['crèmespoeling', 'cremespoeling'],
    'hair_gel': ['haarlak', 'mousse haar'],
    'body_lotion': [
      'lotion',
      'crème',
      'creme',
      'handcrème',
      'dagcrème',
      'nachtcrème',
    ],
    'face_wash': ['reinigingsmelk', 'micellair water', 'serum'],
    'lip_balm': ['labello'],
    'razors': ['scheermes', 'gillette', 'mesjes'],
    'shaving_foam': ['scheergel'],
    'toothbrushes': ['tandenborstel', 'opzetborstels'],
    'dental_floss': ['ragers', 'flossers'],
    'mouthwash': ['listerine'],
    'cotton_pads': ['watjes', 'watten'],
    'cotton_buds': ['oorstokjes', 'q-tips'],
    'sanitary_pads': ['inlegkruisjes'],
    'tampons': ['tampon'],
    'make_up': ['mascara', 'lippenstift', 'foundation', 'nagellak', 'make up'],
    'contact_lens_fluid': ['lenzen'],
    'hand_sanitiser': ['ontsmettende handgel'],
    'bath_foam': ['badzout', 'bruisballen'],
    'cough_syrup': ['keelpastilles', 'hoestsnoepjes'],
    'allergy_tablets': ['antihistaminica', 'hooikoorts'],
    'thermometer': ['koortsthermometer'],
    'first_aid': ['ontsmettingsmiddel', 'isobetadine', 'verband'],
    'insect_repellent': ['anti muggen'],
    'nail_clippers': ['nagelvijl'],
    'baby_formula': ['flesvoeding', 'opvolgmelk', 'kunstvoeding', 'babymelk'],
    'baby_cereal': ['pap baby', 'papjes'],
    'baby_jars': ['potjes', 'groentepotjes', 'fruitpotjes'],
    'baby_snacks': ['soepstengels', 'rijstwafeltjes baby'],
    'baby_shampoo': ['babybad'],
    'nappy_cream': ['zinkzalf', 'sudocrem'],
    'pull_ups': ['pull ups', 'zwemluiers'],
    'dummies': ['tutje', 'speen', 'tut'],
    'baby_bottles': ['papfles', 'zuigfles'],
    'dog_treats': ['kauwbotten', 'hondenkoekjes'],
    'cat_treats': ['catnip'],
    'wet_cat_food': ['kattenvoer blik', 'whiskas', 'sheba', 'felix'],
    'dry_dog_food': ['brokken'],
    'rabbit_food': ['knaagdierenvoer', 'hamstervoer', 'cavia'],
    'hay': ['stro'],
    'poo_bags': ['hondenpoepzakjes'],
    'flea_treatment': ['ontvlooiing', 'vlooienband', 'ontwormingsmiddel'],
    'chicken_feed': ['legmeel', 'graan kippen'],
    'cherry_tomatoes': ['kerstomaatjes', 'cherrytomaatjes'],
    'kitchen_roll': ['keukenpapier'],
    'steak': ['biefstuk'],
    'dishwasher_tabs': ['vaatwasblokjes', 'vaatwastabs'],
    'cat_litter': ['kattenbak'],
    'cheese': ['kaasblokjes'],
    'baking_mix': ['wafelmix', 'cakemix', 'bakmix', 'pannenkoekmix'],
    'skewers': ['spiesjes', 'sate', 'saté', 'kebab', 'brochette'],
  };
}
