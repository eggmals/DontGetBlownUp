import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dont_get_blown_up_game.dart';

class HudComponent extends Component with HasGameReference<DontGetBlownUpGame> {
  late TextComponent _scoreNumber;
  final List<SpriteComponent> _hearts = [];

  static const double _labelH = 65.0;
  static const double _labelW = 130.0;

  HudComponent() : super(priority: 100);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final heartSprite = await game.loadSprite('health_fuel.png');

    final healthLabel = SpriteComponent()
      ..sprite = await game.loadSprite('text_health.png')
      ..size = Vector2(_labelW, _labelH)
      ..position = Vector2(12, 8);
    add(healthLabel);

    for (int i = 0; i < 3; i++) {
      final heart = SpriteComponent()
        ..sprite = heartSprite
        ..size = Vector2(50, 50)
        ..position = Vector2(12 + i * 58.0, 78);
      _hearts.add(heart);
      add(heart);
    }

    final scoreLabel = SpriteComponent()
      ..sprite = await game.loadSprite('text_score.png')
      ..size = Vector2(_labelW, _labelH)
      ..position = Vector2(game.size.x - _labelW - 12, 8);
    add(scoreLabel);

    _scoreNumber = TextComponent(
      text: '0',
      position: Vector2(game.size.x - (_labelW / 2) - 12, 78),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 38,
          fontWeight: FontWeight.w900,
          shadows: [
            Shadow(color: Colors.black, blurRadius: 5, offset: Offset(2, 2)),
          ],
        ),
      ),
    );
    add(_scoreNumber);
  }

  void updateScore(int score) {
    _scoreNumber.text = '$score';
  }

  void updateLives(int lives) {
    for (int i = 0; i < _hearts.length; i++) {
      _hearts[i].opacity = i < lives ? 1.0 : 0.15;
    }
  }
}