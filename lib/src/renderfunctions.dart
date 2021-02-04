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

  RenderBoxFill(terminal, left, top, width, height, fillColor);

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

void RenderBoxFill(
    Terminal terminal, int x, int y, int width, int height, Color color) {
  for (var row = 0; row < height; row++) {
    for (var column = 0; column < width; column++) {
      terminal.drawChar(x + column, y + row, CharCode.space, color, color);
    }
  }
}
