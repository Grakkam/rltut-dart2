import 'dart:math';

import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';

import 'package:rltut/src/actions.dart';
import 'package:rltut/src/engine.dart';
import 'package:rltut/src/renderfunctions.dart';

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

      _action.perform();
      engine.handleEnemyTurn();
      engine.updateFov();
    } else if (controlKeys.containsKey(input)) {
      var cmd = controlKeys[input];
      if (cmd == 'viewHistory') {
        ui.push(LogHistoryScreen(engine));
      }
    }

    ui.refresh();

    return true;
  }

  @override
  void update() {
    dirty();
  }

  @override
  void render(Terminal terminal) {
    engine.render(terminal);
  }
}

class GameOverScreen extends GameScreen {
  GameOverScreen(Engine engine) : super(engine);

  @override
  bool handleInput(String input) {
    if (controlKeys.containsKey(input)) {
      var cmd = controlKeys[input];
      if (cmd == 'viewHistory') {
        ui.push(LogHistoryScreen(engine));
      }
    }

    ui.refresh();

    return true;
  }

  @override
  void render(Terminal terminal) {
    engine.render(terminal);
  }
}

class LogHistoryScreen extends GameScreen {
  int logLength;
  int cursor;
  int adjust = 0;
  final navKeys = {
    'n': -1,
    's': 1,
    'w': -10,
    'e': 10,
    'exit': 'exit',
  };

  LogHistoryScreen(Engine engine) : super(engine) {
    logLength = engine.messageLog.messages.length;
    cursor = logLength - 1;
  }

  @override
  bool handleInput(String input) {
    if (navKeys.containsKey(input)) {
      var navCmd = navKeys[input];
      if (navCmd == 'exit') {
        ui.pop();
      } else {
        adjust = navCmd;
        if (adjust < 0 && cursor == 0) {
          cursor = logLength - 1;
        } else if (adjust > 0 && cursor == logLength - 1) {
          cursor = 0;
        } else {
          cursor = max(0, min(cursor + adjust, logLength - 1));
        }
      }
    }

    ui.refresh();

    return true;
  }

  @override
  void render(Terminal terminal) {
    engine.render(terminal);

    var logX = 3;
    var logY = 3;
    var logWidth = engine.gameMap.width - logX * 2;
    var logHeight = engine.gameMap.height - logY * 2;

    RenderUIBox(
        terminal, logX, logY, logWidth, logHeight, 'Message Log History',
        color: Color.darkAqua, titleColor: Color.darkYellow);

    var messages = engine.messageLog.messages.getRange(0, cursor + 1);
    engine.messageLog.renderMessages(terminal, logX + 2, logY + 2, logWidth - 4,
        logHeight - 4, messages.toList());

    var instructions = 'Scroll with arrows. Press [x] to exit.';

    terminal.writeAt(logX + 2, logY + logHeight + 1, instructions);
  }
}
