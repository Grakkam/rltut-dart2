import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/engine.dart';
import 'package:rltut/src/entity.dart';
import 'package:rltut/src/exceptions.dart';
import 'package:rltut/src/uicolor.dart';

abstract class Action {
  Actor _entity;
  Actor get entity => _entity;
  Engine get engine => _entity.parent.engine;

  set actor(Actor value) => _entity = value;

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
    if (target == null) {
      throw Impossible('Nothing to attack.');
    }

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
    if (!engine.gameMap.inBounds(destination)) {
      throw Impossible('That way is blocked.');
    }
    if (!engine.gameMap.tiles[destination].walkable) {
      throw Impossible('That way is blocked.');
    }
    if (engine.gameMap.getBlockingEntityAtLocation(destination) != null) {
      throw Impossible('That way is blocked.');
    }

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

class ItemAction extends Action {
  final Item _item;
  Vec _targetPos;

  Item get item => _item;
  Vec get targetPos => _targetPos;
  Actor get targetActor => engine.gameMap.getActorAtLocation(targetPos);

  ItemAction(Actor entity, this._item, {Vec targetXY}) : super(entity) {
    if (targetXY != null) {
      _targetPos = targetXY;
    } else {
      _targetPos = entity.pos;
    }
  }

  @override
  void perform() {
    item.consumable.activate(this);
  }
}

class PickupAction extends Action {
  PickupAction(Actor entity) : super(entity);

  @override
  void perform() {
    var actorLocation = entity.pos;
    var inventory = entity.inventory;

    for (var item in engine.gameMap.items) {
      if (actorLocation == item.pos) {
        if (inventory.items.length >= inventory.capacity) {
          throw Impossible('Your inventory is full.');
        }

        engine.gameMap.entities.remove(item);
        item.parent = entity.inventory;
        inventory.items.add(item);
        engine.messageLog.addMessage(text: 'You picked up the ${item.name}!');
        return;
      }
    }

    throw Impossible('There is nothing here to pick up.');
  }
}

class DropItemAction extends ItemAction {
  DropItemAction(Actor entity, Item item) : super(entity, item);

  @override
  void perform() {
    entity.inventory.drop(item);
  }
}
