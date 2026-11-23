/// Tidies names of items the user types. Keep in line with the app's
/// `capitalizeItemName` (`shopping_logic.dart`).
abstract final class ItemNames {
  /// Starts [name] with a capital: "melk" -> "Melk", "ijsblokjes" ->
  /// "IJsblokjes". A first word that already has a capital anywhere
  /// ("iPhone", "pH-strips") is left as typed.
  static String capitalize(String name) {
    if (name.isEmpty) return name;
    final firstWord = name.split(RegExp(r'\s')).first;
    if (firstWord != firstWord.toLowerCase()) return name;
    final first = name[0];
    if (first == first.toUpperCase()) return name;
    if (name.startsWith('ij')) return 'IJ${name.substring(2)}';
    return first.toUpperCase() + name.substring(1);
  }
}
