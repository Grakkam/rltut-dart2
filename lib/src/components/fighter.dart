import 'dart:math';

import 'package:malison/malison.dart';
import 'package:rltut/src/components/basecomponent.dart';
import 'package:rltut/src/entity.dart';
import 'package:rltut/src/renderorder.dart';
import 'package:rltut/src/screens.dart';
import 'package:rltut/src/uicolor.dart';

class Fighter extends BaseComponent {
  int maxHp;
  int _hp;
  int defense;
  int power;

  int get hp => _hp;

  set hp(int value) {
    _hp = max(0, min(value, maxHp));
    if (_hp == 0 && (parent as Actor).ai != null) {
      die();
    }
  }

  void die() {
    String deathMessage;
    Color deathMessageColor;

    if (parent == engine.player) {
      deathMessage = 'You died!';
      deathMessageColor = UIColor.playerDie;
      engine.screen.ui.push(GameOverScreen(engine));
    } else {
      deathMessage = '${parent.name} is dead!';
      deathMessageColor = UIColor.enemyDie;
    }

    parent.char = '%';
    parent.color = Color.red;
    parent.blocksMovement = false;
    (parent as Actor).ai = null;
    parent.name = 'remains of ${parent.name}';
    parent.renderOrder = RenderOrder.corpse;

    engine.messageLog.addMessage(text: deathMessage, fg: deathMessageColor);
  }

  int heal(int amount) {
    if (hp == maxHp) {
      return 0;
    }

    var newHpValue = hp + amount;

    if (newHpValue > maxHp) {
      newHpValue = maxHp;
    }

    var amountRecovered = newHpValue - hp;

    hp = newHpValue;

    return amountRecovered;
  }

  void takeDamage(int amount) {
    hp -= amount;
  }

  Fighter(Actor actor, this.maxHp, this.defense, this.power) {
    parent = actor;
    _hp = maxHp;
  }
}
