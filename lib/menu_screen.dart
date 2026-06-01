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
  }

  Widget _buildGameOverOverlay(BuildContext context, DontGetBlownUpGame game) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.88),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orangeAccent, width: 1.5),
          boxShadow: const [
            BoxShadow(color: Colors.deepOrange, blurRadius: 20, spreadRadius: 1),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo_game.png',
              width: 140,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 4),
            const Text(
              'GAME OVER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
                shadows: [Shadow(color: Colors.redAccent, blurRadius: 10)],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Score: \${game.score}',
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => game.resetGame(),
              child: Image.asset(
                'assets/images/button_playagain.png',
                width: 140,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}