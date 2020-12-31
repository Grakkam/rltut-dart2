import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/gamemap.dart';

class Entity {
  Vec _pos;
  String _char;
  Color _color;
  String _name;
  bool _blocksMovement;

  Vec get pos => _pos;
  int get x => pos.x;
  int get y => pos.y;
  String get char => _char;
  Color get color => _color;
  String get name => _name;
  bool get blocksMovement => _blocksMovement;

  set pos(Vec value) => _pos = value;
  set char(String value) => _char = value;
  set color(Color value) => _color = value;
  set name(String value) => _name = value;
  set blocksMovement(bool value) => _blocksMovement = value;

  Entity(
    this._pos,
    this._char,
    this._color,
    this._name,
    this._blocksMovement,
  );

  void move(int dx, int dy) {
    _pos += Vec(dx, dy);
  }

  Entity.player() {
    _pos = Vec(0, 0);
    _char = '@';
    _color = Color.white;
    _name = 'Player';
    _blocksMovement = true;
  }

  Entity.orc(GameMap dungeon, Vec pos) {
    _pos = pos;
    _char = 'o';
    _color = Color.green;
    _name = 'Orc';
    _blocksMovement = true;
    dungeon.entities.add(this);
  }

  Entity.troll(GameMap dungeon, Vec pos) {
    _pos = pos;
    _char = 'T';
    _color = Color.darkGreen;
    _name = 'Troll';
    _blocksMovement = true;
    dungeon.entities.add(this);
  }
}
