import 'package:malison/malison.dart';

class Tile {
  bool _walkable;
  bool _transparent;
  TileGlyph _dark;

  bool get walkable => _walkable;
  bool get transparent => _transparent;
  TileGlyph get dark => _dark;

  Tile({
    bool walkable,
    bool transparent,
    TileGlyph dark,
  }) {
    _walkable = walkable;
    _transparent = transparent;
    _dark = dark;
  }
}

class TileGlyph {
  String glyph;
  Color fore;
  Color back;

  TileGlyph(this.glyph, this.fore, this.back);
}

class TileTypes {
  static Tile floor = Tile(
    walkable: true,
    transparent: true,
    dark: TileGlyph(' ', Color.white, Color.blue),
  );

  static Tile wall = Tile(
    walkable: false,
    transparent: false,
    dark: TileGlyph(' ', Color.white, Color.darkBlue),
  );
}
