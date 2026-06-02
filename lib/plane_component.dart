import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'dont_get_blown_up_game.dart';
import 'rocket_component.dart';

class PlaneComponent extends SpriteComponent
    with CollisionCallbacks, HasGameReference<DontGetBlownUpGame> {

  bool _flashing = false;
  double _flashTimer = 0;
  bool _visible = true;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(RectangleHitbox(
      size: Vector2(size.x * 0.72, size.y * 0.55),
      position: Vector2(size.x * 0.14, size.y * 0.22),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_flashing) {
      _flashTimer += dt;
      if (_flashTimer >= 0.12) {
        _flashTimer = 0;
        _visible = !_visible;
        opacity = _visible ? 1.0 : 0.2;
      }
    }
  }

  void setFlashing(bool value) {
    _flashing = value;
    if (!value) {
      _flashTimer = 0;
      _visible = true;
      opacity = 1.0;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is RocketComponent && !game.isInvincible) {
      final hitPos = intersectionPoints.fold(
            Vector2.zero(),
            (acc, p) => acc + p,
          ) /
          intersectionPoints.length.toDouble();

      other.removeFromParent();
      game.onHit(hitPos);
    }
  }
}