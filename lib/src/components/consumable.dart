import 'package:rltut/src/actions.dart';
import 'package:rltut/src/components/inventory.dart';
import 'package:rltut/src/entity.dart';
import 'package:rltut/src/components/basecomponent.dart';
import 'package:rltut/src/exceptions.dart';
import 'package:rltut/src/uicolor.dart';

class Consumable extends BaseComponent {
  Consumable();

  Action getAction(Actor consumer) {
    return ItemAction(consumer, parent);
  }

  void activate(ItemAction action) {
    throw NoSuchMethodError;
  }

  void consume() {
    var entity = parent;
    var inventory = entity.parent;
    if (inventory is Inventory) {
      inventory.items.remove(entity);
    }
  }

  // Every class is responsible for creating a clone of itself.
  Consumable clone() {
    return Consumable();
  }
}

class HealingConsumable extends Consumable {
  final int _amount;

  int get amount => _amount;

  HealingConsumable(this._amount) : super();

  @override
  void activate(ItemAction action) {
    var consumer = action.entity;
    var amountRecovered = consumer.fighter.heal(amount);

    if (amountRecovered > 0) {
      engine.messageLog.addMessage(
          text:
              'You consume the ${parent.name}, and recover $amountRecovered hitpoints!',
          fg: UIColor.healthRecovered);
      consume();
    } else {
      throw Impossible('Your health is already full!');
    }
  }

  @override
  HealingConsumable clone() {
    return HealingConsumable(_amount);
  }
}
