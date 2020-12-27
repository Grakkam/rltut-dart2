import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';

class Entity {
  Vec _pos;
  String _char;
  Color _color;

  Vec get pos => _pos;
  int get x => pos.x;
  int get y => pos.y;
  String get char => _char;
  Color get color => _color;

  set char(String value) => _char = value;
  set color(Color value) => _color = value;

  Entity(this._pos, this._char, this._color);

  void move(int dx, int dy) {
    _pos += Vec(dx, dy);
  }
}
