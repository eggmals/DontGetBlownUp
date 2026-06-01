import 'package:flame/components.dart';
import 'dont_get_blown_up_game.dart';

class BackgroundComponent extends Component
    with HasGameRef<DontGetBlownUpGame> {
  late SpriteComponent _bg1;
  late SpriteComponent _bg2;
  final double _scrollSpeed = 180;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await gameRef.loadSprite('background.jpg');
    final bgSize = Vector2(gameRef.size.x, gameRef.size.y);

    _bg1 = SpriteComponent()
      ..sprite = sprite
      ..size = bgSize
      ..position = Vector2.zero();

    _bg2 = SpriteComponent()
      ..sprite = sprite
      ..size = bgSize
      ..position = Vector2(bgSize.x, 0);

    gameRef.add(_bg1);
    gameRef.add(_bg2);
  }

  @override
  void update(double dt) {
    super.update(dt);

    _bg1.position.x -= _scrollSpeed * dt;
    _bg2.position.x -= _scrollSpeed * dt;

    if (_bg1.position.x + _bg1.size.x <= 0) {
      _bg1.position.x = _bg2.position.x + _bg2.size.x;
    }
    if (_bg2.position.x + _bg2.size.x <= 0) {
      _bg2.position.x = _bg1.position.x + _bg1.size.x;
    }
  }
}