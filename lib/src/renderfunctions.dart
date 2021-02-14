import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/engine.dart';
import 'package:rltut/src/gamemap.dart';

import 'package:rltut/src/uicolor.dart';

void renderBar(
    Terminal terminal, int currentValue, int maximumValue, int totalWidth) {
  var barWidth = (currentValue / maximumValue * totalWidth).toInt();

  var barText =
      ' HP: $currentValue/$maximumValue'.padRight(totalWidth).runes.toList();

  var barBG;
  for (var x = 0; x < barText.length; x++) {
    if (x < barWidth) {
      barBG = UIColor.barFilled;
    } else {
      barBG = UIColor.barEmpty;
    }
    terminal.drawGlyph(
        0 + x, 45, Glyph.fromCharCode(barText[x], UIColor.barText, barBG));
  }
}

List getNamesAtLocation(Vec pos, GameMap gameMap) {
  var names = [];

  if (gameMap.inBounds(pos) && gameMap.visible[pos]) {
    var entities = gameMap.entities.where((element) => element.pos == pos);

    for (var entity in entities) {
      names.add(entity.name);
    }
  }

  return names;
}

void renderNamesAtMouseLocation(
    Terminal terminal, int x, int y, Engine engine) {
  var namesAtMouseLocation =
      getNamesAtLocation(engine.mousePos, engine.gameMap);
  if (namesAtMouseLocation.isNotEmpty) {
    terminal.writeAt(x, y, namesAtMouseLocation.toString());
  }
}

class UIBox {
  final int _x;
  final int _y;
  final int _width;
  final int _height;
  int _left;
  int _right;
  int _top;
  int _bottom;
  Color _color;
  Color _backColor;
  Color _titleColor;
  Color _titleBackColor;
  Color _fillColor;
  String _borderChars;
  String _title;

  UIBox(this._x, this._y, this._width, this._height,
      {String title,
      Color color = Color.white,
      Color backColor = Color.black,
      Color fillColor = Color.black,
      Color titleColor = Color.white,
      Color titleBackColor = Color.black}) {
    _color = color;
    _backColor = backColor;
    _fillColor = fillColor;
    _titleColor = titleColor;
    _titleBackColor = titleBackColor;
    _title = title ?? '';
    _left = _x;
    _right = _x + _width;
    _top = _y;
    _bottom = _y + _height;
    _borderChars = '╔╗╚╝║═╡╞';
  }

  void render(Terminal terminal) {
    terminal.fill(_left + 1, _top + 1, _width - 1, _height - 1, _fillColor);
    for (var x = 0; x < _width; x++) {
      terminal.drawChar(
          _left + x, _top, _borderChars.codeUnitAt(5), _color, _backColor);
      terminal.drawChar(
          _left + x, _bottom, _borderChars.codeUnitAt(5), _color, _backColor);
    }
    for (var y = 0; y < _height; y++) {
      terminal.drawChar(
          _left, _top + y, _borderChars.codeUnitAt(4), _color, _backColor);
      terminal.drawChar(
          _right, _top + y, _borderChars.codeUnitAt(4), _color, _backColor);
    }
    terminal.drawChar(
        _left, _top, _borderChars.codeUnitAt(0), _color, _backColor);
    terminal.drawChar(
        _right, _top, _borderChars.codeUnitAt(1), _color, _backColor);
    terminal.drawChar(
        _left, _bottom, _borderChars.codeUnitAt(2), _color, _backColor);
    terminal.drawChar(
        _right, _bottom, _borderChars.codeUnitAt(3), _color, _backColor);

    if (_title.isNotEmpty) {
      var title = ' ' + _title + ' ';
      terminal.drawChar(
          _left + 2, _top, _borderChars.codeUnitAt(6), _color, _backColor);
      terminal.writeAt(_left + 3, _top, title, _titleColor, _titleBackColor);
      terminal.drawChar(_left + title.length + 3, _top,
          _borderChars.codeUnitAt(7), _color, _backColor);
    }
  }
}

/*

void RenderUIBox(
    Terminal terminal, int left, int top, int width, int height, String title,
    {Color color = Color.white,
    Color bgcolor = Color.black,
    Color titleColor = Color.white,
    Color titleBgcolor = Color.black,
    Color fillColor = Color.black,
    bool single = false}) {
  var right = left + width;
  var bottom = top + height;

  terminal.backColor = bgcolor;
  terminal.fill(left, top, width, height);

  title = ' ' + title + ' ';
  RenderBoxTitle(terminal, left + 2, top, title,
      color: titleColor, bgcolor: titleBgcolor);

  RenderBoxLineVertical(terminal, left, top + 1, bottom - 1,
      color: color, bgcolor: bgcolor, single: single);
  RenderBoxLineVertical(terminal, right, top + 1, bottom - 1,
      color: color, bgcolor: bgcolor, single: single);
  RenderBoxLineHorizontal(terminal, bottom, left + 1, right - 1,
      color: color, bgcolor: bgcolor, single: single);

  RenderBoxLineEndRight(terminal, left + 1, top,
      color: color, bgcolor: bgcolor, single: single);
  RenderBoxLineHorizontal(terminal, top, left + 2 + title.length + 1, right - 1,
      color: color, bgcolor: bgcolor, single: single);
  RenderBoxLineEndLeft(terminal, left + 1 + title.length + 1, top,
      color: color, bgcolor: bgcolor, single: single);

  RenderBoxCornerTopLeft(terminal, left, top,
      color: color, bgcolor: bgcolor, single: single);
  RenderBoxCornerTopRight(terminal, right, top,
      color: color, bgcolor: bgcolor, single: single);
  RenderBoxCornerBottomLeft(terminal, left, bottom,
      color: color, bgcolor: bgcolor, single: single);
  RenderBoxCornerBottomRight(terminal, right, bottom,
      color: color, bgcolor: bgcolor, single: single);
}

void RenderBoxTitle(Terminal terminal, int x, int y, String text,
    {Color color = Color.white, Color bgcolor = Color.black}) {
  terminal.writeAt(x, y, text, color, bgcolor);
}

void RenderBoxLineVertical(Terminal terminal, int x, int top, int bottom,
    {Color color = Color.white,
    Color bgcolor = Color.black,
    bool single = false}) {
  int charCode;

  charCode = single
      ? CharCode.boxDrawingsLightVertical
      : CharCode.boxDrawingsDoubleVertical;

  for (var y = 0; y < bottom - top + 1; y++) {
    terminal.drawChar(x, top + y, charCode, color, bgcolor);
  }
}

void RenderBoxLineHorizontal(Terminal terminal, int y, int left, int right,
    {Color color = Color.white,
    Color bgcolor = Color.black,
    bool single = false}) {
  int charCode;

  charCode = single
      ? CharCode.boxDrawingsLightHorizontal
      : CharCode.boxDrawingsDoubleHorizontal;

  for (var x = 0; x < right - left + 1; x++) {
    terminal.drawChar(left + x, y, charCode, color, bgcolor);
  }
}

void RenderBoxCornerTopLeft(Terminal terminal, int x, int y,
    {Color color = Color.white,
    Color bgcolor = Color.black,
    bool single = false}) {
  int charCode;

  charCode = single
      ? CharCode.boxDrawingsLightDownAndRight
      : CharCode.boxDrawingsDoubleDownAndRight;

  terminal.drawChar(x, y, charCode, color, bgcolor);
}

void RenderBoxCornerTopRight(Terminal terminal, int x, int y,
    {Color color = Color.white,
    Color bgcolor = Color.black,
    bool single = false}) {
  int charCode;

  charCode = single
      ? CharCode.boxDrawingsLightDownAndLeft
      : CharCode.boxDrawingsDoubleDownAndLeft;

  terminal.drawChar(x, y, charCode, color, bgcolor);
}

void RenderBoxCornerBottomLeft(Terminal terminal, int x, int y,
    {Color color = Color.white,
    Color bgcolor = Color.black,
    bool single = false}) {
  int charCode;

  charCode = single
      ? CharCode.boxDrawingsLightUpAndRight
      : CharCode.boxDrawingsDoubleUpAndRight;

  terminal.drawChar(x, y, charCode, color, bgcolor);
}

void RenderBoxCornerBottomRight(Terminal terminal, int x, int y,
    {Color color = Color.white,
    Color bgcolor = Color.black,
    bool single = false}) {
  int charCode;

  charCode = single
      ? CharCode.boxDrawingsLightUpAndLeft
      : CharCode.boxDrawingsDoubleUpAndLeft;

  terminal.drawChar(x, y, charCode, color, bgcolor);
}

void RenderBoxLineEndRight(Terminal terminal, int x, int y,
    {Color color = Color.white,
    Color bgcolor = Color.black,
    bool single = false}) {
  int charCode;

  charCode = single
      ? CharCode.boxDrawingsVerticalDoubleAndLeftSingle
      : CharCode.boxDrawingsVerticalSingleAndLeftDouble;

  terminal.drawChar(x, y, charCode, color, bgcolor);
}

void RenderBoxLineEndLeft(Terminal terminal, int x, int y,
    {Color color = Color.white,
    Color bgcolor = Color.black,
    bool single = false}) {
  int charCode;

  charCode = single
      ? CharCode.boxDrawingsVerticalDoubleAndRightSingle
      : CharCode.boxDrawingsVerticalSingleAndRightDouble;

  terminal.drawChar(x, y, charCode, color, bgcolor);
}

*/
