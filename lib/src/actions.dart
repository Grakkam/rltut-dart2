import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/engine.dart';
import 'package:rltut/src/entity.dart';

abstract class Action {
  void perform(Engine engine, Entity entity);
}

class MovementAction extends Action {
  final int _dx;
  final int _dy;

  int get dx => _dx;
  int get dy => _dy;

  MovementAction(this._dx, this._dy);

  @override
  void perform(Engine engine, Entity entity) {
    var dest = entity.pos + Vec(dx, dy);

    if (!engine.gameMap.inBounds(dest)) return;
    if (!engine.gameMap.tiles[dest].walkable) return;

    entity.move(dx, dy);
  }
}
