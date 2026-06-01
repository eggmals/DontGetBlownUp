import 'package:flame/components.dart';

class ExplosionComponent extends SpriteComponent {
  final double _duration = 0.5;
  double _timer = 0;

  ExplosionComponent({required Sprite sprite}) {
    this.sprite = sprite;
    size = Vector2(80, 80);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;
    opacity = (1.0 - (_timer / _duration)).clamp(0.0, 1.0);
    final s = 1.0 + (_timer / _duration) * 0.5;
    scale = Vector2.all(s);

    if (_timer >= _duration) {
      removeFromParent();
    }
  }
}