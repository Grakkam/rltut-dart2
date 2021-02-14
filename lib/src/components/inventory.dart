import 'package:rltut/src/components/basecomponent.dart';
import 'package:rltut/src/entity.dart';

class Inventory extends BaseComponent {
  final int _capacity;
  final List _items = [];

  Inventory(this._capacity);

  int get capacity => _capacity;
  List get items => _items;

  void drop(Item item) {
    _items.remove(item);
    item.place(parent.x, parent.y, gameMap);

    engine.messageLog.addMessage(text: 'You dropped the ${item.name}.');
  }
}
