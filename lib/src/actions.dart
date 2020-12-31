import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/engine.dart';
import 'package:rltut/src/entity.dart';

abstract class Action {
  void perform(Engine engine, Entity entity);
}

abstract class ActionWithDirection extends Action {
  final int _dx;
  final int _dy;

  int get dx => _dx;
  int get dy => _dy;

  ActionWithDirection(this._dx, this._dy);

  @override
  void perform(Engine engine, Entity entity);
}

class MovementAction extends ActionWithDirection {
  MovementAction(int dx, int dy) : super(dx, dy);

  @override
  void perform(Engine engine, Entity entity) {
    var dest = entity.pos + Vec(dx, dy);

    if (!engine.gameMap.inBounds(dest)) return;
    if (!engine.gameMap.tiles[dest].walkable) return;
    if (engine.gameMap.getBlockingEntityAtLocation(dest) != null) return;

    entity.move(dx, dy);
  }
}

class MeleeAction extends ActionWithDirection {
  MeleeAction(int dx, int dy) : super(dx, dy);

  @override
  void perform(Engine engine, Entity entity) {
    var dest = entity.pos + Vec(dx, dy);
    var target = engine.gameMap.getBlockingEntityAtLocation(dest);
    if (target == null) return;

    print('You kick the ${target.name}!');
  }
}

class BumpAction extends ActionWithDirection {
  BumpAction(int dx, int dy) : super(dx, dy);

  @override
  void perform(Engine engine, Entity entity) {
    var dest = entity.pos + Vec(dx, dy);
    if (engine.gameMap.getBlockingEntityAtLocation(dest) != null) {
      return MeleeAction(dx, dy).perform(engine, entity);
    } else {
      return MovementAction(dx, dy).perform(engine, entity);
    }
  }
}
