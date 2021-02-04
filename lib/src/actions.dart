import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/engine.dart';
import 'package:rltut/src/entity.dart';
import 'package:rltut/src/uicolor.dart';

abstract class Action {
  final Actor _entity;
  Actor get entity => _entity;
  Engine get engine => _entity.gameMap.engine;

  Action(this._entity);

  void perform();
}

class WaitAction extends Action {
  @override
  void perform() {}

  WaitAction(Actor entity) : super(entity);
}

abstract class ActionWithDirection extends Action {
  Vec _direction;
  final int _dx;
  final int _dy;

  Vec get direction => _direction;
  int get dx => _dx;
  int get dy => _dy;

  Vec get destination => entity.pos + direction;
  Entity get blockingEntity =>
      engine.gameMap.getBlockingEntityAtLocation(destination);
  Actor get targetActor => engine.gameMap.getActorAtLocation(destination);

  ActionWithDirection(Actor entity, this._dx, this._dy) : super(entity) {
    _direction = Vec(_dx, _dy);
  }

  @override
  void perform();
}

class MeleeAction extends ActionWithDirection {
  MeleeAction(Actor entity, int dx, int dy) : super(entity, dx, dy);

  @override
  void perform() {
    var target = targetActor;
    if (target == null) return;

    var damage = entity.fighter.power - target.fighter.defense;

    var attackDesc = '${entity.name} attacks ${target.name}';
    var attackColor = UIColor.playerAttack;
    if (entity != engine.player) {
      attackColor = UIColor.enemyAttack;
    }
    if (damage > 0) {
      engine.messageLog.addMessage(
          text: '$attackDesc for $damage hit points.', fg: attackColor);
      target.fighter.hp -= damage;
    } else {
      engine.messageLog
          .addMessage(text: '$attackDesc but does no damage.', fg: attackColor);
    }
  }
}

class MovementAction extends ActionWithDirection {
  MovementAction(Actor entity, int dx, int dy) : super(entity, dx, dy);

  @override
  void perform() {
    if (!engine.gameMap.inBounds(destination)) return;
    if (!engine.gameMap.tiles[destination].walkable) return;
    if (engine.gameMap.getBlockingEntityAtLocation(destination) != null) return;

    entity.move(dx, dy);
  }
}

class BumpAction extends ActionWithDirection {
  BumpAction(Actor entity, int dx, int dy) : super(entity, dx, dy);

  @override
  void perform() {
    if (targetActor != null) {
      return MeleeAction(entity, dx, dy).perform();
    } else {
      return MovementAction(entity, dx, dy).perform();
    }
  }
}
