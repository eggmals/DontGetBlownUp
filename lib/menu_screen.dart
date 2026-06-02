import 'package:flutter/material.dart';
import 'package:flame/game.dart';
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
          color: Colors.black.withValues(alpha: 0.45),
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

  void _startGame(BuildContext context) {
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

    Future.delayed(const Duration(milliseconds: 400), () {
      game.startAudio();
    });
  }

  Widget _buildGameOverOverlay(BuildContext context, DontGetBlownUpGame game) {
    final finalScore = game.score;
    return Container(
      color: Colors.black.withValues(alpha: 0.75),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/game_over.png',
              width: 380,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => game.resetGame(),
              child: Image.asset(
                'assets/images/button_playagain.png',
                width: 180,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Score: $finalScore',
              style: const TextStyle(
                color: Color(0xFFFF8C00),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 6,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}