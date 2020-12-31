import 'dart:math' as math;

import 'package:piecemeal/piecemeal.dart';

import 'package:rltut/src/entity.dart';
import 'package:rltut/src/gamemap.dart';
import 'package:rltut/src/tiletypes.dart';

GameMap generateDungeon(int maxRooms, int roomMinSize, int roomMaxSize,
    int mapWidth, int mapHeight, Entity player) {
  var dungeon = GameMap(mapWidth, mapHeight);
  var random = math.Random();

  List<Room> rooms;
  rooms = [];

  for (var i = 0; i < maxRooms; i++) {
    var roomWidth = roomMinSize + random.nextInt(roomMaxSize - roomMinSize);
    var roomHeight = roomMinSize + random.nextInt(roomMaxSize - roomMinSize);

    var x = random.nextInt(mapWidth - roomWidth - 1) + 1;
    var y = random.nextInt(mapHeight - roomHeight - 1) + 1;

    var newRoom = Room(x, y, roomWidth, roomHeight);

    var intersects = false;

    rooms.forEach((room) {
      if (room.intersects(newRoom)) intersects = true;
    });

    // If the room intersects another room, trash it and try again.
    if (intersects) continue;

    // If the room is valid, carve it out.
    for (var pos in newRoom.inner) {
      dungeon.tiles[pos] = TileTypes.floor;
    }

    if (rooms.isEmpty) {
      // This is the first room, where the player starts.
      player.pos = newRoom.center;
    } else {
      // Connect the room with the previous room.
      for (var tunnel in tunnelBetween(rooms.last.center, newRoom.center)) {
        for (var pos in tunnel) {
          dungeon.tiles[pos] = TileTypes.floor;
        }
      }
    }

    rooms.add(newRoom);
  }

  return dungeon;
}

class Room extends Rect {
  Room(int x, int y, int width, int height) : super(x, y, width, height);

  Rect get inner => Rect(x + 1, y + 1, width - 2, height - 2);

  bool intersects(Room other) {
    return Rect.intersect(this, other).area > 0;
  }
}

List<Rect> tunnelBetween(Vec start, Vec end) {
  List<Rect> tunnels;
  tunnels = [];
  Vec corner;
  var random = math.Random();

  if (random.nextBool()) {
    corner = Vec(end.x, start.y);
    tunnels.add(Rect.row(
        math.min(start.x, corner.x), corner.y, (start.x - corner.x).abs() + 1));
    tunnels.add(Rect.column(
        corner.x, math.min(corner.y, end.y), (corner.y - end.y).abs() + 1));
  } else {
    corner = Vec(start.x, end.y);
    tunnels.add(Rect.column(
        start.x, math.min(start.y, corner.y), (start.y - corner.y).abs() + 1));
    tunnels.add(Rect.row(
        math.min(corner.x, end.x), end.y, (corner.x - end.x).abs() + 1));
  }

  return tunnels;
}
