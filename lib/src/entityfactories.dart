import 'package:malison/malison.dart';
import 'package:rltut/src/components/ai.dart';
import 'package:rltut/src/components/consumable.dart';
import 'package:rltut/src/components/fighter.dart';
import 'package:rltut/src/components/inventory.dart';
import 'package:rltut/src/entity.dart';

class Player extends Actor {
  Player()
      : super(null, '@', Color.white, 'Player', HostileEnemy(null),
            Fighter(null, 30, 2, 5), Inventory(26));
}

// class Orc extends Actor {
//   Orc()
//       : super(null, 'o', Color.green, 'Orc', HostileEnemy(null),
//             Fighter(null, 10, 0, 3));
// }

// class Troll extends Actor {
//   Troll()
//       : super(null, 'T', Color.darkGreen, 'Troll', HostileEnemy(null),
//             Fighter(null, 16, 1, 4));
// }

// class HealthPotion extends Item {
//   HealthPotion()
//       : super(null, '!', Color.purple, 'Health Potion', HealingConsumable(4));
// }

class Monster {
  static Actor orc = Actor(null, 'o', Color.green, 'Orc', HostileEnemy(null),
      Fighter(null, 10, 0, 3), Inventory(0));
  static Actor troll = Actor(null, 'T', Color.darkGreen, 'Troll',
      HostileEnemy(null), Fighter(null, 16, 1, 4), Inventory(0));
}

class Potion {
  static Item healthPotion =
      Item(null, '!', Color.purple, 'Health Potion', HealingConsumable(4));
}
