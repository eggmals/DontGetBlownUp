import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'dont_get_blown_up_game.dart';

// Tipe roket:
// 1 — Kecil & cepat  : lurus
// 2 — Medium         : zigzag vertikal kecil
// 3 — Besar & lambat : gelombang vertikal besar
class RocketComponent extends SpriteComponent
    with CollisionCallbacks, HasGameReference<DontGetBlownUpGame> {
  final int rocketType;
  final double speed;

  double _waveTimer = 0;
  final double _waveAmplitude;
  final double _waveFrequency;

  RocketComponent({
    required this.rocketType,
    required this.speed,
  })  : _waveAmplitude = rocketType == 2
            ? 40.0
            : rocketType == 3
                ? 70.0
                : 0.0,
        _waveFrequency = rocketType == 2
            ? 2.0
            : rocketType == 3
                ? 1.2
                : 0.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final padX = size.x * 0.1;
    final padY = size.y * 0.15;
    add(RectangleHitbox(
      size: Vector2(size.x - padX * 2, size.y - padY * 2),
      position: Vector2(padX, padY),
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.x -= speed * dt;

    if (rocketType != 1) {
      _waveTimer += dt;
      final dir = (_waveTimer % 2 < 1) ? 1 : -1;
      position.y += _waveAmplitude * _waveFrequency * dt *
          (rocketType == 2 ? 0.8 : 0.5) *
          dir;

      final halfH = size.y / 2;
      if (position.y < halfH) position.y = halfH;
      if (position.y > game.size.y - halfH) {
        position.y = game.size.y - halfH;
      }
    }

    if (position.x < -size.x - 10) {
      removeFromParent();
    }
  }
}