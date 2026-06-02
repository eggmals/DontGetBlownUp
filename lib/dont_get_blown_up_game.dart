import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'audio_manager.dart';
import 'background_component.dart';
import 'plane_component.dart';
import 'rocket_component.dart';
import 'hud_component.dart';
import 'explosion_component.dart';

class DontGetBlownUpGame extends FlameGame
    with DragCallbacks, HasCollisionDetection {

  int lives = 3;
  int score = 0;
  bool isInvincible = false;

  late PlaneComponent plane;
  late HudComponent hud;

  late Sprite rocketSprite1;
  late Sprite rocketSprite2;
  late Sprite rocketSprite3;
  late Sprite explosionSprite;

  double _spawnTimer = 0;
  double _spawnInterval = 2.0;
  final double _minSpawnInterval = 0.6;
  double _scoreTimer = 0;
  double _invincibleTimer = 0;

  final Random _random = Random();
  final AudioManager _audio = AudioManager();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(BackgroundComponent());

    rocketSprite1   = await loadSprite('rocket1.png');
    rocketSprite2   = await loadSprite('rocket2.png');
    rocketSprite3   = await loadSprite('rocket3.png');
    explosionSprite = await loadSprite('explossion.png');

    plane = PlaneComponent()
      ..sprite = await loadSprite('jet.png')
      ..size = Vector2(130, 75)
      ..position = Vector2(size.x * 0.06, size.y * 0.55)
      ..anchor = Anchor.center;
    add(plane);

    hud = HudComponent();
    add(hud);
  }

  Future<void> startAudio() async {
    await _audio.init();
    _audio.playBgm();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    plane.position.y += event.localDelta.y;

    final halfH = plane.size.y / 2;
    if (plane.position.y < halfH) plane.position.y = halfH;
    if (plane.position.y > size.y - halfH) plane.position.y = size.y - halfH;

    final halfW = plane.size.x / 2;
    if (plane.position.x < halfW) plane.position.x = halfW;
    if (plane.position.x > size.x - halfW) plane.position.x = size.x - halfW;
  }

  @override
  void update(double dt) {
    super.update(dt);

    _scoreTimer += dt;
    if (_scoreTimer >= 1.0) {
      _scoreTimer = 0;
      score += 1;
      hud.updateScore(score);
      _spawnInterval = max(_minSpawnInterval, 2.0 - (score * 0.02));
    }

    _spawnTimer += dt;
    if (_spawnTimer >= _spawnInterval) {
      _spawnTimer = 0;
      _spawnRocket();
    }

    if (_gameOverPending) {
      _gameOverTimer += dt;
      if (_gameOverTimer >= _gameOverDelay) {
        _gameOverPending = false;
        _gameOver();
      }
    }

    if (isInvincible) {
      _invincibleTimer += dt;
      if (_invincibleTimer >= 1.5) {
        isInvincible = false;
        _invincibleTimer = 0;
        plane.setFlashing(false);
      }
    }
  }

  void _spawnRocket() {
    final roll = _random.nextDouble();
    int rocketType;
    if (roll < 0.50) {
      rocketType = 1;
    } else if (roll < 0.85) {
      rocketType = 2;
    } else {
      rocketType = 3;
    }

    final spawnY = _random.nextDouble() * (size.y - 80) + 40;

    Sprite sprite;
    Vector2 rocketSize;
    double speed;

    switch (rocketType) {
      case 1:
        sprite = rocketSprite1;
        rocketSize = Vector2(70, 28);
        speed = 420 + _random.nextDouble() * 80;
        break;
      case 2:
        sprite = rocketSprite2;
        rocketSize = Vector2(100, 36);
        speed = 280 + _random.nextDouble() * 60;
        break;
      case 3:
      default:
        sprite = rocketSprite3;
        rocketSize = Vector2(130, 48);
        speed = 160 + _random.nextDouble() * 40;
        break;
    }

    final rocket = RocketComponent(rocketType: rocketType, speed: speed)
      ..sprite = sprite
      ..size = rocketSize
      ..position = Vector2(size.x + rocketSize.x, spawnY)
      ..anchor = Anchor.center;
    add(rocket);

    _audio.playSfx('roket', volume: 0.6);
  }

  bool _gameOverPending = false;
  double _gameOverTimer = 0;
  static const double _gameOverDelay = 0.9;

  void onHit(Vector2 hitPosition) {
    if (isInvincible) return;

    lives--;
    hud.updateLives(lives);

    _audio.playSfx('meledak', volume: 1.0);

    if (lives <= 0) {
      plane.opacity = 0;
      final bigExplosion = ExplosionComponent(sprite: explosionSprite, big: true)
        ..position = plane.position.clone()
        ..anchor = Anchor.center;
      add(bigExplosion);
      _gameOverPending = true;
      _gameOverTimer = 0;
    } else {
      isInvincible = true;
      plane.setFlashing(true);

      final explosion = ExplosionComponent(sprite: explosionSprite)
        ..position = hitPosition
        ..anchor = Anchor.center;
      add(explosion);
    }
  }

  void _gameOver() {
    _audio.stopBgm();
    pauseEngine();
    overlays.add('GameOver');
  }

  void resetGame() {
    lives = 3;
    score = 0;
    isInvincible = false;
    _invincibleTimer = 0;
    _spawnTimer = 0;
    _spawnInterval = 2.0;
    _scoreTimer = 0;
    _gameOverPending = false;
    _gameOverTimer = 0;

    children.whereType<RocketComponent>().forEach((r) => r.removeFromParent());
    children.whereType<ExplosionComponent>().forEach((e) => e.removeFromParent());

    plane.position = Vector2(size.x * 0.06, size.y * 0.55);
    plane.setFlashing(false);
    plane.opacity = 1.0;

    hud.updateLives(3);
    hud.updateScore(0);

    overlays.remove('GameOver');
    resumeEngine();

    _audio.playBgm();
  }

  @override
  void onDispose() {
    _audio.dispose();
    super.onDispose();
  }
}