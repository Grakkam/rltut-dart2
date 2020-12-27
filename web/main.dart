import 'dart:html' as html;
import 'dart:js';
import 'dart:math' as math;

import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';

import 'package:rltut/src/actions.dart';

final screenWidth = 80;
final screenHeight = 45;
var playerX = screenWidth ~/ 2;
var playerY = screenHeight ~/ 2;

class GameScreen extends Screen<String> {
  var _action;

  GameScreen();

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

    if (_action is MovementAction) {
      playerX += _action.dx;
      playerY += _action.dy;
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
    terminal.writeAt(playerX, playerY, '@');
  }
}

// --------------------

final _fonts = <TerminalFont>[];
UserInterface<String> _ui;

TerminalFont _font;

class TerminalFont {
  final String name;
  final html.CanvasElement canvas;
  RenderableTerminal terminal;
  final int charWidth;
  final int charHeight;

  TerminalFont(this.name, this.canvas, this.terminal,
      {this.charWidth, this.charHeight});
} // End of class TerminalFont

void main() {
  _addFont('8x8', 8);
  _addFont('16x16', 16);

  var fontName = html.window.localStorage['font'];
  _font = _fonts[1];
  for (var thisFont in _fonts) {
    if (thisFont.name == fontName) {
      _font = thisFont;
      break;
    }
  }

  var div = html.querySelector('#game');
  div.append(_font.canvas);

  html.window.onResize.listen((_) {
    _resizeTerminal();
  });

  _ui = UserInterface<String>(_font.terminal);

  _ui.keyPress.bind('n', KeyCode.up);
  _ui.keyPress.bind('e', KeyCode.right);
  _ui.keyPress.bind('s', KeyCode.down);
  _ui.keyPress.bind('w', KeyCode.left);

  _ui.push(GameScreen());

  _ui.handlingInput = true;
} // End of main()

void _addFont(String name, int charWidth, [int charHeight]) {
  charHeight ??= charWidth;

  var canvas = html.CanvasElement();
  canvas.onDoubleClick.listen((_) {
    _fullscreen();
  });

  var terminal = _makeTerminal(canvas, charWidth, charHeight);
  _fonts.add(TerminalFont(name, canvas, terminal,
      charWidth: charWidth, charHeight: charHeight));

  var button = html.ButtonElement();
  button.innerHtml = name;
  button.onClick.listen((_) {
    for (var i = 0; i < _fonts.length; i++) {
      if (_fonts[i].name == name) {
        _font = _fonts[i];
        html.querySelector('#game').append(_font.canvas);
      } else {
        _fonts[i].canvas.remove();
      }
    }

    _resizeTerminal();

    html.window.localStorage['font'] = name;
  });

  html.querySelector('.button-bar').children.add(button);
} // End of _addFont()

void _fullscreen() {
  var div = html.querySelector('#game');
  var jsElement = JsObject.fromBrowserObject(div);

  var methods = [
    'requestFullscreen',
    'mozRequestFullScreen',
    'webkitRequestFullscreen',
    'msRequestFullscreen'
  ];
  for (var method in methods) {
    if (jsElement.hasProperty(method)) {
      jsElement.callMethod(method);
      return;
    }
  }
} // End of _fullscreen()

RetroTerminal _makeTerminal(
  html.CanvasElement canvas,
  int charWidth,
  int charHeight,
) {
  var width = (html.document.body.clientWidth - 20) ~/ charWidth;
  var height = (html.document.body.clientHeight - 30) ~/ charHeight;

  width = math.max(width, screenWidth);
  height = math.max(height, screenWidth);

  var scale = html.window.devicePixelRatio.toInt();
  var canvasWidth = charWidth * width;
  var canvasHeight = charHeight * height;
  canvas.width = canvasWidth * scale;
  canvas.height = canvasHeight * scale;
  canvas.style.width = '${canvasWidth}px';
  canvas.style.height = '${canvasHeight}px';

  var file = 'assets/fonts/font_$charWidth';
  if (charWidth != charHeight) {
    file += '_$charHeight';
  }
  return RetroTerminal(width, height, '$file.png',
      canvas: canvas, charWidth: charWidth, charHeight: charHeight);
} // End of _makeTerminal()

void _resizeTerminal() {
  var terminal = _makeTerminal(_font.canvas, _font.charWidth, _font.charHeight);

  _font.terminal = terminal;
  _ui.setTerminal(terminal);
  _ui.refresh();
} // End of _resizeTerminal()
