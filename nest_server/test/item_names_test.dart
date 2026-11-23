import 'package:nest_server/src/services/item_names.dart';
import 'package:test/test.dart';

void main() {
  String c(String name) => ItemNames.capitalize(name);

  test('starts a typed name with a capital', () {
    expect(c('melk'), 'Melk');
    expect(c('rode ui'), 'Rode ui');
    expect(c('éclairs'), 'Éclairs');
  });

  test('Dutch ij becomes IJ', () {
    expect(c('ijsblokjes'), 'IJsblokjes');
    expect(c('ijs'), 'IJs');
  });

  test('leaves names that already have a capital or no letter first', () {
    expect(c('Melk'), 'Melk');
    expect(c('iPhone kabel'), 'iPhone kabel');
    expect(c('pH-strips'), 'pH-strips');
    expect(c('7up'), '7up');
    expect(c(''), '');
  });
}
