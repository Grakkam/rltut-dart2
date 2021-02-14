import 'dart:math';

import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';

import 'package:rltut/src/actions.dart';
import 'package:rltut/src/engine.dart';
import 'package:rltut/src/entity.dart';
import 'package:rltut/src/entityfactories.dart';
import 'package:rltut/src/exceptions.dart';
import 'package:rltut/src/renderfunctions.dart';
import 'package:rltut/src/uicolor.dart';

class GameScreen extends Screen<String> {
  final Engine _engine;
  Action _action;

  Engine get engine => _engine;

  GameScreen(this._engine);
}

class MainGameScreen extends GameScreen {
  bool _timeToUpdate = false;
  MainGameScreen(Engine engine) : super(engine);

  @override
  bool handleInput(String input) {
    var player = engine.player;

    if (moveKeys.containsKey(input)) {
      var dir = moveKeys[input];
      player.nextAction = BumpAction(player, dir.x, dir.y);
    } else if (controlKeys.containsKey(input)) {
      var cmd = controlKeys[input];
      if (cmd == 'viewHistory') {
        ui.push(LogHistoryScreen(engine));
        return false;
      }
      if (cmd == 'pickup') {
        player.nextAction = PickupAction(player);
      }
      if (cmd == 'drop') {
        ui.push(DropItemScreen(engine));
        return false;
      }
      if (cmd == 'use') {
        ui.push(UseItemScreen(engine));
        return false;
      }
    }

    if (player.nextAction != null) {
      _action = player.nextAction;
      player.nextAction = null;
    }

    if (_action != null) {
      try {
        _action.perform();
        _action = null;
      } on Impossible catch (e) {
        engine.messageLog.addMessage(text: '$e', fg: UIColor.impossible);
        return false;
      }
      _timeToUpdate = true;
    }

    return true;
  }

  @override
  void activate(Screen screen, Object result) {
    if (result) {
      if (engine.player.nextAction != null) {
        try {
          engine.player.nextAction.perform();
          engine.player.nextAction = null;
          _timeToUpdate = true;
        } on Impossible catch (e) {
          engine.messageLog.addMessage(text: '$e', fg: UIColor.impossible);
        }
      }
    }
  }

  @override
  void update() {
    if (_timeToUpdate) {
      engine.handleEnemyTurn();
      engine.updateFov();

      _timeToUpdate = false;
    }
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

class InventoryScreen extends GameScreen {
  String title;
  UIBox inventoryWindow;
  Player player;
  int nrOfItems;
  int height;
  int width;
  int x;
  int y;
  Item selectedItem;

  InventoryScreen(Engine engine, {String title}) : super(engine) {
    title = title ?? 'Inventory';
    player = engine.player;
    nrOfItems = player.inventory.items.length;
    height = nrOfItems + 2;
    if (height < 3) {
      height = 3;
    }
    if (player.pos.x <= 30) {
      x = 40;
    } else {
      x = 0;
    }
    y = 0;
    width = title.length + 12;
    inventoryWindow = UIBox(x, y, width, height,
        title: title, color: Color.darkAqua, titleColor: Color.darkYellow);
  }

  @override
  bool keyDown(int keyCode, {bool shift, bool alt}) {
    if (keyCode == KeyCode.escape) {
      ui.pop(false);
      return true;
    }
    if (keyCode >= KeyCode.a && keyCode <= KeyCode.z) {
      var index = (keyCode - KeyCode.a).toInt();
      if (index >= 0 && index < nrOfItems) {
        selectedItem = player.inventory.items[index];
        onItemSelected(selectedItem);
        ui.pop(true);
      }
    }

    return false;
  }

  void onItemSelected(Item item) {}

  @override
  void render(Terminal terminal) {
    engine.render(terminal);
    inventoryWindow.render(terminal);
    if (nrOfItems > 0) {
      var i = 0;
      for (var item in engine.player.inventory.items) {
        terminal.drawChar(x + 1, y + 1 + i, CharCode.aLower + i);
        terminal.writeAt(x + 3, y + 1 + i, item.name, item.color);
        i++;
      }
    } else {
      terminal.writeAt(x + 1, y + 1, '(Empty)', UIColor.impossible);
    }
  }
}

class UseItemScreen extends InventoryScreen {
  UseItemScreen(Engine engine) : super(engine, title: 'Select an item to use');
  @override
  void onItemSelected(Item item) {
    player.nextAction = item.consumable.getAction(player);
  }
}

class DropItemScreen extends InventoryScreen {
  DropItemScreen(Engine engine)
      : super(engine, title: 'Select an item to drop');

  @override
  void onItemSelected(Item item) {
    player.nextAction = DropItemAction(player, item);
  }
}

class LogHistoryScreen extends GameScreen {
  int logLength;
  int cursor;
  int adjust = 0;
  UIBox logWindow;
  int logX;
  int logY;
  int logWidth;
  int logHeight;

  LogHistoryScreen(Engine engine) : super(engine) {
    logLength = engine.messageLog.messages.length;
    cursor = logLength - 1;
    logX = 3;
    logY = 3;
    logWidth = engine.gameMap.width - logX * 2;
    logHeight = engine.gameMap.height - logY * 2;
    logWindow = UIBox(
      logX,
      logY,
      logWidth,
      logHeight,
      title: 'Message Log History',
      color: Color.darkAqua,
      titleColor: Color.darkYellow,
    );
  }

  @override
  bool keyDown(int keyCode, {bool shift, bool alt}) {
    if (keyCode == KeyCode.escape) {
      ui.pop();
    }

    if (keyCode >= KeyCode.left && keyCode <= KeyCode.down) {
      if (keyCode == KeyCode.up) {
        adjust = -1;
      } else if (keyCode == KeyCode.down) {
        adjust = 1;
      }
      if (shift) {
        adjust *= 10;
      }

      if (adjust < 0 && cursor == 0) {
        cursor = logLength - 1;
      } else if (adjust > 0 && cursor == logLength - 1) {
        cursor = 0;
      } else {
        cursor = max(0, min(cursor + adjust, logLength - 1));
      }
    }

    return false;
  }

  @override
  void render(Terminal terminal) {
    engine.render(terminal);

    logWindow.render(terminal);

    var messages = engine.messageLog.messages.getRange(0, cursor + 1);
    engine.messageLog.renderMessages(terminal, logX + 2, logY + 2, logWidth - 4,
        logHeight - 4, messages.toList());
  }
}
