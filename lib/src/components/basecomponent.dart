import 'package:rltut/src/engine.dart';
import 'package:rltut/src/entity.dart';
import 'package:rltut/src/gamemap.dart';

abstract class BaseComponent {
  Entity _parent;

  BaseComponent();

  Entity get parent => _parent;
  set parent(Entity value) => _parent = value;

  GameMap get gameMap => parent.gameMap;
  Engine get engine => parent.gameMap.engine;
}
