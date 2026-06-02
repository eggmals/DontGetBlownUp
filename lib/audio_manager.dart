import 'dart:js_interop';
import 'package:web/web.dart' as web;


class AudioManager {
  web.AudioContext? _ctx;
  web.AudioBuffer? _bufferBgm;
  web.AudioBuffer? _bufferRoket;
  web.AudioBuffer? _bufferMeledak;
  web.AudioBufferSourceNode? _bgmSource;

  bool get isReady => _ctx != null && _bufferBgm != null;

  Future<void> init() async {
    _ctx = web.AudioContext();
    _bufferBgm     = await _load('assets/audio/bgm.mp3');
    _bufferRoket   = await _load('assets/audio/roket.mp3');
    _bufferMeledak = await _load('assets/audio/meledak.mp3');
  }

  Future<web.AudioBuffer?> _load(String url) async {
    try {
      final response = await web.window.fetch(url.toJS).toDart;
      final arrayBuffer = await response.arrayBuffer().toDart;
      return await _ctx!.decodeAudioData(arrayBuffer).toDart;
    } catch (_) {
      return null;
    }
  }

  void playBgm() {
    if (_ctx == null || _bufferBgm == null) return;
    try {
      _stopBgm();
      final source = _ctx!.createBufferSource();
      source.buffer = _bufferBgm;
      source.loop = true;

      final gain = _ctx!.createGain();
      gain.gain.value = 0.4;

      source.connect(gain);
      gain.connect(_ctx!.destination);
      source.start();
      _bgmSource = source;
    } catch (_) {}
  }

  void _stopBgm() {
    try {
      _bgmSource?.stop();
      _bgmSource = null;
    } catch (_) {}
  }

  void stopBgm() => _stopBgm();

  void playSfx(String name, {double volume = 1.0}) {
    if (_ctx == null) return;
    web.AudioBuffer? buffer;
    if (name == 'roket') buffer = _bufferRoket;
    if (name == 'meledak') buffer = _bufferMeledak;
    if (buffer == null) return;

    try {
      final source = _ctx!.createBufferSource();
      source.buffer = buffer;

      final gain = _ctx!.createGain();
      gain.gain.value = volume;

      source.connect(gain);
      gain.connect(_ctx!.destination);
      source.start();
    } catch (_) {}
  }

  void dispose() {
    _stopBgm();
    try {
      _ctx?.close();
    } catch (_) {}
    _ctx = null;
  }
}