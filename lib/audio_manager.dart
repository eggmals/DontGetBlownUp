import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  bool isReady = false;

  Future<void> init() async {
    await FlameAudio.audioCache.loadAll([
      'bgm.mp3',
      'roket.mp3',
      'meledak.mp3',
    ]);
    isReady = true;
  }

  void playBgm() {
    FlameAudio.bgm.play('bgm.mp3', volume: 0.4);
  }

  void stopBgm() {
    FlameAudio.bgm.stop();
  }

  void playSfx(String name, {double volume = 1.0}) {
    if (name == 'roket') FlameAudio.play('roket.mp3', volume: volume);
    if (name == 'meledak') FlameAudio.play('meledak.mp3', volume: volume);
  }

  void dispose() {
    stopBgm();
    FlameAudio.audioCache.clearAll();
  }
}