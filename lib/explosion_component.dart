import 'package:flame/components.dart';

class ExplosionComponent extends SpriteComponent {
  final double _duration;
  double _timer = 0;

  ExplosionComponent({required Sprite sprite, bool big = false})
      : _duration = big ? 0.9 : 0.5 {
    this.sprite = sprite;
    size = big ? Vector2(200, 200) : Vector2(90, 90);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;

    opacity = (1.0 - (_timer / _duration)).clamp(0.0, 1.0);
    final s = 1.0 + (_timer / _duration) * 0.8;
    scale = Vector2.all(s);

    if (_timer >= _duration) removeFromParent();
  }
}