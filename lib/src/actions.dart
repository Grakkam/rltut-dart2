abstract class Action {}

class MovementAction extends Action {
  final int _dx;
  final int _dy;

  int get dx => _dx;
  int get dy => _dy;

  MovementAction(this._dx, this._dy);
}
