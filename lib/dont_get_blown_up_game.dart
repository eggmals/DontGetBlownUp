import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
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

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Background scrolling
    add(BackgroundComponent());

    // Load sprites
    rocketSprite1   = await loadSprite('rocket1.png');
    rocketSprite2   = await loadSprite('rocket2.png');
    rocketSprite3   = await loadSprite('rocket3.png');
    explosionSprite = await loadSprite('explossion.png');

    // Pesawat pemain
    plane = PlaneComponent()
      ..sprite = await loadSprite('jet.png')
      ..size = Vector2(130, 75)
      ..position = Vector2(size.x * 0.06, size.y * 0.55)
      ..anchor = Anchor.center;
    add(plane);

    // HUD
    hud = HudComponent();
    add(hud);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    plane.position.y += event.localDelta.y;

    // Batas atas & bawah
    final halfH = plane.size.y / 2;
    if (plane.position.y < halfH) plane.position.y = halfH;
    if (plane.position.y > size.y - halfH) plane.position.y = size.y - halfH;

    // Batas kiri & kanan
    final halfW = plane.size.x / 2;
    if (plane.position.x < halfW) plane.position.x = halfW;
    if (plane.position.x > size.x - halfW) plane.position.x = size.x - halfW;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Skor naik per detik
    _scoreTimer += dt;
    if (_scoreTimer >= 1.0) {
      _scoreTimer = 0;
      score += 1;
      hud.updateScore(score);
      // Makin tinggi skor, makin sering spawn
      _spawnInterval = max(_minSpawnInterval, 2.0 - (score * 0.02));
    }

    // Spawn roket
    _spawnTimer += dt;
    if (_spawnTimer >= _spawnInterval) {
      _spawnTimer = 0;
      _spawnRocket();
    }

    // Hitung mundur game over pending
    if (_gameOverPending) {
      _gameOverTimer += dt;
      if (_gameOverTimer >= _gameOverDelay) {
        _gameOverPending = false;
        _gameOver();
      }
    }

    // Hitung mundur invincible
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
    // Bobot spawn: tipe1 50%, tipe2 35%, tipe3 15%
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
  }

  bool _gameOverPending = false;
  double _gameOverTimer = 0;
  static const double _gameOverDelay = 0.9;

  // Dipanggil PlaneComponent saat tabrakan
  void onHit(Vector2 hitPosition) {
    if (isInvincible) return;

    lives--;
    hud.updateLives(lives);

    if (lives <= 0) {
      // Ledakan besar & sembunyikan pesawat, lalu delay game over
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

      // Efek ledakan kecil
      final explosion = ExplosionComponent(sprite: explosionSprite)
        ..position = hitPosition
        ..anchor = Anchor.center;
      add(explosion);
    }
  }

  void _gameOver() {
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

    // Bersihkan roket & ledakan
    children.whereType<RocketComponent>().forEach((r) => r.removeFromParent());
    children.whereType<ExplosionComponent>().forEach((e) => e.removeFromParent());

    // Reset pesawat
    plane.position = Vector2(size.x * 0.06, size.y * 0.55);
    plane.setFlashing(false);
    plane.opacity = 1.0;

    // Reset HUD
    hud.updateLives(3);
    hud.updateScore(0);

    overlays.remove('GameOver');
    resumeEngine();
  }
}