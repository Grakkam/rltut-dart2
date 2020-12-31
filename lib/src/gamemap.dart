import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';

import 'package:rltut/src/tiletypes.dart';

class GameMap {
  final int _width;
  final int _height;
  Array2D _tiles;
  Array2D _visible;
  Array2D _explored;

  int get width => _width;
  int get height => _height;
  Rect get bounds => _tiles.bounds;
  Array2D get tiles => _tiles;
  Array2D get visible => _visible;
  Array2D get explored => _explored;

  GameMap(this._width, this._height) {
    _tiles = Array2D(_width, _height, TileTypes.wall);
    _visible = Array2D(_width, _height, false);
    _explored = Array2D(_width, _height, false);
  }

  bool inBounds(Vec pos) {
    return tiles.bounds.contains(pos);
  }

  void render(Terminal terminal) {
    for (var pos in tiles.bounds) {
      var tile = tiles[pos];
      if (visible[pos]) {
        terminal.writeAt(
            pos.x, pos.y, tile.light.glyph, tile.light.fore, tile.light.back);
      } else if (explored[pos]) {
        terminal.writeAt(
            pos.x, pos.y, tile.dark.glyph, tile.dark.fore, tile.dark.back);
      }
    }
  }
}
