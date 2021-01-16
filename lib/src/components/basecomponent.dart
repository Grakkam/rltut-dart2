import 'package:rltut/src/engine.dart';
import 'package:rltut/src/entity.dart';

abstract class BaseComponent {
  Actor entity;

  Engine get engine => entity.gameMap.engine;
}
