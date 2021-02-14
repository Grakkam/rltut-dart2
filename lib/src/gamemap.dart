import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:rltut/src/engine.dart';
import 'package:rltut/src/entity.dart';

import 'package:rltut/src/tiletypes.dart';

class GameMap {
  final Engine _engine;
  final int _width;
  final int _height;
  final List<Entity> _entities;
  Array2D _tiles;
  Array2D _visible;
  Array2D _explored;

  GameMap get gameMap => this;
  Engine get engine => _engine;
  int get width => _width;
  int get height => _height;
  Rect get bounds => _tiles.bounds;
  List get entities => _entities;
  Array2D get tiles => _tiles;
  Array2D get visible => _visible;
  Array2D get explored => _explored;
  bool validDestination(Vec pos) => inBounds(pos) && _tiles[pos].walkable;

  GameMap(this._engine, this._width, this._height, this._entities) {
    _tiles = Array2D(_width, _height, TileTypes.wall);
    _visible = Array2D(_width, _height, false);
    _explored = Array2D(_width, _height, false);
  }

  List<Actor> get actors {
    return _entities.whereType<Actor>().toList();
  }

  List<Item> get items {
    return _entities.whereType<Item>().toList();
  }

  Actor getActorAtLocation(Vec pos) {
    for (var actor in actors) {
      if (actor.pos == pos && actor.isAlive) {
        return actor;
      }
    }
    return null;
  }

  bool inBounds(Vec pos) {
    return tiles.bounds.contains(pos);
  }

  Entity getBlockingEntityAtLocation(Vec location) {
    for (var entity in entities) {
      if (entity.blocksMovement && entity.pos == location) {
        return entity;
      }
    }

    return null;
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

    var sortedEntities = entities;
    sortedEntities
        .sort((a, b) => a.renderOrder.index.compareTo(b.renderOrder.index));

    for (var entity in sortedEntities) {
      if (visible[entity.pos]) {
        terminal.writeAt(entity.x, entity.y, entity.char, entity.color,
            tiles[entity.pos].light.back);
      }
    }
  }
}
