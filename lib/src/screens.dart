import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';

import 'package:rltut/src/actions.dart';
import 'package:rltut/src/engine.dart';

class GameScreen extends Screen<String> {
  final Engine _engine;
  Engine get engine => _engine;

  GameScreen(this._engine);
}

class MainGameScreen extends GameScreen {
  Action _action;

  MainGameScreen(Engine engine) : super(engine);

  @override
  bool handleInput(String input) {
    var player = engine.player;

    if (moveKeys.containsKey(input)) {
      var dir = moveKeys[input];
      _action = BumpAction(player, dir.x, dir.y);
    }

    _action.perform();
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
    terminal.writeAt(1, 47,
        'HP: ${engine.player.fighter.hp}/${engine.player.fighter.maxHp}');
  }
}

class GameOverScreen extends GameScreen {
  GameOverScreen(Engine engine) : super(engine);

  @override
  void render(Terminal terminal) {
    engine.gameMap.render(terminal);
    terminal.writeAt(1, 47,
        'HP: ${engine.player.fighter.hp}/${engine.player.fighter.maxHp}');
  }
}
