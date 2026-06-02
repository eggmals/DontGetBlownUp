import 'package:flame/components.dart';
import 'dont_get_blown_up_game.dart';

class BackgroundComponent extends Component
    with HasGameReference<DontGetBlownUpGame> {
  late SpriteComponent _bg1;
  late SpriteComponent _bg2;
  final double _scrollSpeed = 180;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await game.loadSprite('background.jpg');
    final bgSize = Vector2(game.size.x, game.size.y);

    _bg1 = SpriteComponent()
      ..sprite = sprite
      ..size = bgSize
      ..position = Vector2.zero();

    _bg2 = SpriteComponent()
      ..sprite = sprite
      ..size = bgSize
      ..position = Vector2(bgSize.x, 0);

    game.add(_bg1);
    game.add(_bg2);
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