import 'package:piecemeal/piecemeal.dart';

import 'package:rltut/src/entity.dart';
import 'package:rltut/src/fov.dart';
import 'package:rltut/src/gamemap.dart';
import 'package:rltut/src/screens.dart';

final moveKeys = {
  'n': Vec(0, -1),
  's': Vec(0, 1),
  'w': Vec(-1, 0),
  'e': Vec(1, 0),
  'ne': Vec(1, -1),
  'se': Vec(1, 1),
  'nw': Vec(-1, -1),
  'sw': Vec(-1, 1),
};

class Engine {
  final Actor _player;
  GameMap _gameMap;
  Fov _fov;
  GameScreen _screen;

  Actor get player => _player;
  GameMap get gameMap => _gameMap;
  Fov get fov => _fov;
  GameScreen get screen => _screen;

  set gameMap(GameMap value) => _gameMap = value;
  set fov(Fov value) => _fov = value;
  set screen(GameScreen value) => _screen = value;

  Engine(this._player) {
    _screen = MainGameScreen(this);
  }

  void updateFov() {
    fov.refresh(player.pos);
    for (var pos in gameMap.bounds) {
      if (gameMap.visible[pos]) {
        gameMap.explored[pos] = true;
      }
    }
  }

  void handleEnemyTurn() {
    var enemies = gameMap.actors;
    enemies.remove(player);
    for (var entity in enemies) {
      if (entity.ai != null) {
        entity.ai.perform();
      }
    }
  }
}
