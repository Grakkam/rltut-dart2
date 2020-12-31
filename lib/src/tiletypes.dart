import 'package:malison/malison.dart';

class Tile {
  bool _walkable;
  bool _transparent;
  TileGlyph _dark;
  TileGlyph _light;

  bool get walkable => _walkable;
  bool get transparent => _transparent;
  TileGlyph get dark => _dark;
  TileGlyph get light => _light;

  Tile({
    bool walkable,
    bool transparent,
    TileGlyph dark,
    TileGlyph light,
  }) {
    _walkable = walkable;
    _transparent = transparent;
    _dark = dark;
    _light = light;
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
    light: TileGlyph(' ', Color.white, Color.gold),
  );

  static Tile wall = Tile(
    walkable: false,
    transparent: false,
    dark: TileGlyph(' ', Color.white, Color.darkBlue),
    light: TileGlyph(' ', Color.white, Color.darkGold),
  );
}
