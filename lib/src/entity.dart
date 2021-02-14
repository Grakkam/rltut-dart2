import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/actions.dart';
import 'package:rltut/src/components/ai.dart';
import 'package:rltut/src/components/consumable.dart';
import 'package:rltut/src/components/fighter.dart';
import 'package:rltut/src/components/inventory.dart';
import 'package:rltut/src/gamemap.dart';
import 'package:rltut/src/renderorder.dart';

class Entity {
  var _parent;
  Vec _pos;
  String _char;
  Color _color;
  String _name;
  bool _blocksMovement;
  RenderOrder _renderOrder;

  GameMap get gameMap => _parent.gameMap;
  dynamic get parent => _parent;
  Vec get pos => _pos;
  int get x => pos.x;
  int get y => pos.y;
  String get char => _char;
  Color get color => _color;
  String get name => _name;
  bool get blocksMovement => _blocksMovement;
  RenderOrder get renderOrder => _renderOrder;

  // set gameMap(GameMap value) => _parent = value;
  set parent(dynamic value) => _parent = value;
  set pos(Vec value) => _pos = value;
  set char(String value) => _char = value;
  set color(Color value) => _color = value;
  set name(String value) => _name = value;
  set blocksMovement(bool value) => _blocksMovement = value;
  set renderOrder(RenderOrder value) => _renderOrder = value;

  Entity(this._pos, this._char, this._color, this._name, this._blocksMovement,
      this._renderOrder,
      [dynamic parent]) {
    if (parent != null) {
      _parent = parent;
      _parent.entities.add(this);
    }
  }

  void move(int dx, int dy) {
    _pos += Vec(dx, dy);
  }

  Entity spawn(GameMap gameMap, int x, int y) {
    var clone = Entity(pos, char, color, name, blocksMovement, renderOrder);
    clone.pos = Vec(x, y);
    clone.parent = gameMap;
    gameMap.entities.add(clone);

    return clone;
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
  Inventory _inventory;
  Action _nextAction;

  BaseAI get ai => _ai;
  set ai(BaseAI value) => _ai = value;
  Fighter get fighter => _fighter;
  Inventory get inventory => _inventory;
  bool get isAlive => _ai != null;
  Action get nextAction => _nextAction;

  set nextAction(Action value) => _nextAction = value;

  Actor(Vec pos, String char, Color color, String name, BaseAI aiClass,
      Fighter fighterComponent, Inventory inventory)
      : super(pos, char, color, name, true, RenderOrder.actor) {
    _ai = aiClass;
    _ai.actor = this;
    _fighter = fighterComponent;
    _fighter.parent = this;
    _inventory = inventory;
    _inventory.parent = this;
  }

  @override
  Actor spawn(GameMap gameMap, int x, int y) {
    var clone = Actor(
        pos,
        char,
        color,
        name,
        HostileEnemy(this),
        Fighter(this, fighter.maxHp, fighter.defense, fighter.power),
        Inventory(inventory.capacity));
    clone.pos = Vec(x, y);
    clone.parent = gameMap;
    gameMap.entities.add(clone);

    return clone;
  }
}

class Item extends Entity {
  final Consumable _consumable;

  Consumable get consumable => _consumable;

  Item(Vec pos, String char, Color color, String name, this._consumable)
      : super(pos, char, color, name, false, RenderOrder.item) {
    _consumable.parent = this;
  }

  @override
  Item spawn(GameMap gameMap, int x, int y) {
    var clone = Item(pos, char, color, name, consumable.clone());
    clone.pos = Vec(x, y);
    clone.parent = gameMap;
    gameMap.entities.add(clone);

    return clone;
  }
}
