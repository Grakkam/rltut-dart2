import 'package:rltut/src/engine.dart';
import 'package:rltut/src/entity.dart';
import 'package:rltut/src/gamemap.dart';

abstract class BaseComponent {
  Entity parent;

  BaseComponent(this.parent);

  GameMap get gameMap => parent.gameMap;
  Engine get engine => parent.gameMap.engine;
}
