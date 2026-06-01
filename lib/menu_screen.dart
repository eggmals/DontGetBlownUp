import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'dont_get_blown_up_game.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.45),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_game.png',
                  width: 320,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 48),
                GestureDetector(
                  onTap: () => _startGame(context),
                  child: Image.asset(
                    'assets/images/button_play.png',
                    width: 180,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Drag up/down to dodge rockets!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi dijadikan async untuk memicu BGM
  void _startGame(BuildContext context) async {
    // Inisialisasi dan jalankan BGM setelah ada interaksi (taps)
    await FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('bgm.mp3', volume: 0.5);

    final game = DontGetBlownUpGame();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: GameWidget<DontGetBlownUpGame>(
            game: game,
            overlayBuilderMap: {
              'GameOver': (context, game) =>
                  _buildGameOverOverlay(context, game),
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverOverlay(BuildContext context, DontGetBlownUpGame game) {
    // Ambil score sekarang dan simpan — supaya tidak berubah saat widget rebuild
    final finalScore = game.score;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.88),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orangeAccent, width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.deepOrange,
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gambar game_over.png
            Image.asset(
              'assets/images/game_over.png',
              width: 220,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            Text(
              'Score: $finalScore',
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(color: Colors.black, blurRadius: 4),
                ],
              ),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () {
                FlameAudio.bgm.stop();
                game.resetGame();
              },
              child: Image.asset(
                'assets/images/button_playagain.png',
                width: 150,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}