import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';

import 'package:rltut/src/tiletypes.dart';

class GameMap {
  final int _width;
  final int _height;
  Array2D _tiles;

  int get width => _width;
  int get height => _height;
  Array2D get tiles => _tiles;

  GameMap(this._width, this._height) {
    _tiles = Array2D(_width, _height, TileTypes.floor);

    tiles[Vec(30, 22)] = TileTypes.wall;
    tiles[Vec(31, 22)] = TileTypes.wall;
    tiles[Vec(32, 22)] = TileTypes.wall;
  }

  bool inBounds(Vec pos) {
    return tiles.bounds.contains(pos);
  }

  void render(Terminal terminal) {
    for (var pos in tiles.bounds) {
      var tile = tiles[pos];
      terminal.writeAt(
          pos.x, pos.y, tile.dark.glyph, tile.dark.fore, tile.dark.back);
    }
  }
}
