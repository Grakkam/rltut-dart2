import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/components/ai.dart';
import 'package:rltut/src/components/fighter.dart';
import 'package:rltut/src/gamemap.dart';
import 'package:rltut/src/renderorder.dart';

class Entity {
  GameMap _parent;
  Vec _pos;
  String _char;
  Color _color;
  String _name;
  bool _blocksMovement;
  RenderOrder _renderOrder;

  GameMap get gameMap => _parent.gameMap;
  GameMap get parent => _parent;
  Vec get pos => _pos;
  int get x => pos.x;
  int get y => pos.y;
  String get char => _char;
  Color get color => _color;
  String get name => _name;
  bool get blocksMovement => _blocksMovement;
  RenderOrder get renderOrder => _renderOrder;

  set gameMap(GameMap value) => _parent = value;
  // set parent(GameMap value) => _parent = value;
  set pos(Vec value) => _pos = value;
  set char(String value) => _char = value;
  set color(Color value) => _color = value;
  set name(String value) => _name = value;
  set blocksMovement(bool value) => _blocksMovement = value;
  set renderOrder(RenderOrder value) => _renderOrder = value;

  Entity(this._pos, this._char, this._color, this._name, this._blocksMovement,
      this._renderOrder,
      [GameMap parent]) {
    if (parent != null) {
      _parent = parent;
      _parent.entities.add(this);
    }
  }

  void move(int dx, int dy) {
    _pos += Vec(dx, dy);
  }

  void place(int x, int y, [GameMap dungeon]) {
    _pos = Vec(x, y);
    if (dungeon != null) {
      if (parent != null) {
        gameMap.entities.remove(this);
      }
      _parent = dungeon;
      gameMap.entities.add(this);
    }
  }
}

class Actor extends Entity {
  BaseAI _ai;
  Fighter _fighter;

  BaseAI get ai => _ai;
  set ai(BaseAI value) => _ai = value;
  Fighter get fighter => _fighter;
  bool get isAlive => _ai != null;

  Actor(Vec pos, String char, Color color, String name, BaseAI aiClass,
      Fighter fighterComponent)
      : super(pos, char, color, name, true, RenderOrder.actor) {
    _ai = aiClass;
    _ai.actor = this;
    _fighter = fighterComponent;
    _fighter.parent = this;
  }
}
