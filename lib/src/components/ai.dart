import 'dart:math';

import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/actions.dart';
import 'package:rltut/src/astar.dart';
import 'package:rltut/src/components/basecomponent.dart';
import 'package:rltut/src/entity.dart';

class BaseAI extends Action with BaseComponent {
  Actor actor;

  @override
  void perform() {}

  List getPathTo(Vec destination) {
    return Astar.findPath(entity.gameMap, entity.pos, destination);
  }

  BaseAI(Actor actor) : super(actor);
}

class HostileEnemy extends BaseAI {
  List _path = [];

  HostileEnemy(Entity actor) : super(actor);

  @override
  void perform() {
    var target = engine.player;
    var direction = target.pos - entity.pos;
    var distance =
        max(direction.x.abs(), direction.y.abs()); // Chebyshev distance.

    if (engine.gameMap.visible[entity.pos]) {
      if (distance <= 1) {
        return MeleeAction(entity, direction.x, direction.y).perform();
      }
      _path = getPathTo(target.pos);
    }

    if (_path != null && _path.isNotEmpty) {
      var direction = _path[1] - entity.pos;
      return MovementAction(entity, direction.x, direction.y).perform();
    }

    return WaitAction(entity).perform();
  }
}
