import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dont_get_blown_up_game.dart';

class HudComponent extends Component with HasGameRef<DontGetBlownUpGame> {
  late TextComponent _scoreNumber;
  final List<SpriteComponent> _hearts = [];

  // text_health.png & text_score.png ukuran asli 1667×834 → rasio 2:1
  static const double _labelH = 50.0;
  static const double _labelW = 100.0; // 50 * (1667/834) ≈ 100

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final heartSprite = await gameRef.loadSprite('health_fuel.png');

    // Label "HEALTH"
    final healthLabel = SpriteComponent()
      ..sprite = await gameRef.loadSprite('text_health.png')
      ..size = Vector2(_labelW, _labelH)
      ..position = Vector2(12, 8);
    gameRef.add(healthLabel);

    // Ikon hati × 3
    for (int i = 0; i < 3; i++) {
      final heart = SpriteComponent()
        ..sprite = heartSprite
        ..size = Vector2(42, 42)
        ..position = Vector2(12 + i * 50.0, 64);
      _hearts.add(heart);
      gameRef.add(heart);
    }

    // Label "SCORE"
    final scoreLabel = SpriteComponent()
      ..sprite = await gameRef.loadSprite('text_score.png')
      ..size = Vector2(_labelW, _labelH)
      ..position = Vector2(gameRef.size.x - _labelW - 12, 8);
    gameRef.add(scoreLabel);

    // Angka skor
    _scoreNumber = TextComponent(
      text: '0',
      position: Vector2(gameRef.size.x - (_labelW / 2) - 12, 64),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.w900,
          shadows: [
            Shadow(color: Colors.black, blurRadius: 4, offset: Offset(1, 1)),
          ],
        ),
      ),
    );
    gameRef.add(_scoreNumber);
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