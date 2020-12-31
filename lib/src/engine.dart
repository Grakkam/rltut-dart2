import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';

import 'package:rltut/src/actions.dart';
import 'package:rltut/src/entity.dart';
import 'package:rltut/src/fov.dart';
import 'package:rltut/src/gamemap.dart';

class Engine {
  final List<Entity> _entities;
  final GameMap _gameMap;
  final Entity _player;
  final Fov _fov;

  List get entities => _entities;
  GameMap get gameMap => _gameMap;
  Entity get player => _player;
  Fov get fov => _fov;

  Engine(this._entities, this._gameMap, this._player, this._fov) {
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
        _action = MovementAction(0, -1);
        break;
      case 's':
        _action = MovementAction(0, 1);
        break;
      case 'w':
        _action = MovementAction(-1, 0);
        break;
      case 'e':
        _action = MovementAction(1, 0);
        break;
      default:
        return false;
    }

    engine.updateFov();
    _action.perform(engine, engine.player);

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
    for (var entity in engine.entities) {
      if (engine.gameMap.visible[entity.pos]) {
        terminal.writeAt(entity.x, entity.y, entity.char, entity.color,
            engine.gameMap.tiles[entity.pos].light.back);
      }
    }
  }
}
