import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';

import 'package:rltut/src/actions.dart';
import 'package:rltut/src/entity.dart';
import 'package:rltut/src/fov.dart';
import 'package:rltut/src/gamemap.dart';

class Engine {
  final GameMap _gameMap;
  final Entity _player;
  final Fov _fov;

  GameMap get gameMap => _gameMap;
  Entity get player => _player;
  Fov get fov => _fov;

  Engine(this._gameMap, this._player, this._fov) {
    updateFov();
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
    for (var i = 1; i < gameMap.entities.length; i++) {
      print('The ${gameMap.entities[i].name} hangs around, doing nothing.');
    }
  }
}

class GameScreen extends Screen<String> {
  final Engine _engine;

  Action _action;

  Engine get engine => _engine;

  GameScreen(this._engine);

  @override
  bool handleInput(String input) {
    switch (input) {
      case 'n':
        _action = BumpAction(0, -1);
        break;
      case 's':
        _action = BumpAction(0, 1);
        break;
      case 'w':
        _action = BumpAction(-1, 0);
        break;
      case 'e':
        _action = BumpAction(1, 0);
        break;
      default:
        return false;
    }

    _action.perform(engine, engine.player);
    engine.handleEnemyTurn();
    engine.updateFov();

    ui.refresh();

    return true;
  }

  @override
  void update() {
    dirty();
  }

  @override
  void render(Terminal terminal) {
    engine.gameMap.render(terminal);
  }
}
