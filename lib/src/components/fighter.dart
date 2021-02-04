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
    if (_hp == 0 && entity.isAlive) {
      die();
    }
  }

  void die() {
    String deathMessage;
    Color deathMessageColor;

    if (entity == engine.player) {
      deathMessage = 'You died!';
      deathMessageColor = UIColor.playerDie;
      engine.screen.ui.push(GameOverScreen(engine));
    } else {
      deathMessage = '${entity.name} is dead!';
      deathMessageColor = UIColor.enemyDie;
    }

    entity.char = '%';
    entity.color = Color.red;
    entity.blocksMovement = false;
    entity.ai = null;
    entity.name = 'remains of ${entity.name}';
    entity.renderOrder = RenderOrder.corpse;

    engine.messageLog.addMessage(text: deathMessage, fg: deathMessageColor);
  }

  Fighter(Actor actor, this.maxHp, this.defense, this.power) {
    entity = actor;
    _hp = maxHp;
  }
}
