import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'dont_get_blown_up_game.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _showTutorial = false;
  int _tutorialPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMainMenu(context),
          if (_showTutorial) _buildTutorialOverlay(context),
        ],
      ),
    );
  }

  Widget _buildMainMenu(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withValues(alpha: 0.45),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_game.png',
                  height: screenHeight * 0.4, 
                  fit: BoxFit.contain,
                ),
                SizedBox(height: screenHeight * 0.05), 
                GestureDetector(
                  onTap: () => _startGame(context),
                  child: Image.asset(
                    'assets/images/button_play.png',
                    height: screenHeight * 0.15,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                GestureDetector(
                  onTap: _openTutorial,
                  child: Image.asset(
                    'assets/images/button_tutorial.png',
                    height: screenHeight * 0.15,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Text(
                  'Drag up/down to dodge rockets!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: screenHeight * 0.04, 
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

  Widget _buildTutorialOverlay(BuildContext context) {
    final isFirstSlide = _tutorialPage == 0;
    final isSecondSlide = _tutorialPage == 1;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.black.withValues(alpha: 0.85),
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: screenWidth * 0.85,  
              height: screenHeight * 0.85, 
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/panel.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Image.asset(
                      'assets/images/howtoplay.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  
                  Expanded(
                    flex: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.08, 
                          child: isSecondSlide
                              ? GestureDetector(
                                  onTap: () => setState(() => _tutorialPage = 0),
                                  child: Image.asset(
                                    'assets/images/button_previous.png',
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Image.asset(
                              isFirstSlide
                                  ? 'assets/images/jet_atasbawah.png'
                                  : 'assets/images/health_fuel.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        SizedBox(
                          width: screenWidth * 0.08, 
                          child: isFirstSlide
                              ? GestureDetector(
                                  onTap: () => setState(() => _tutorialPage = 1),
                                  child: Image.asset(
                                    'assets/images/button_next.png',
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        isFirstSlide
                            ? 'Drag Up/Down the plane to dodge the rocket'
                            : 'Mind the health fuel to survive',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.025, 
                          fontWeight: FontWeight.bold,
                          shadows: const [
                            Shadow(color: Colors.black, blurRadius: 5, offset: Offset(2, 2)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: _closeTutorial,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white54, width: 2),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openTutorial() {
    setState(() {
      _showTutorial = true;
      _tutorialPage = 0;
    });
  }

  void _closeTutorial() {
    setState(() {
      _showTutorial = false;
      _tutorialPage = 0;
    });
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
    
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.black.withValues(alpha: 0.75),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/game_over.png',
                height: screenHeight * 0.40, 
                fit: BoxFit.contain,
              ),
              SizedBox(height: screenHeight * 0.03), 
              GestureDetector(
                onTap: () => game.resetGame(),
                child: Image.asset(
                  'assets/images/button_playagain.png',
                  height: screenHeight * 0.12, 
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: screenHeight * 0.02), 
              Text(
                'Score: $finalScore',
                style: TextStyle(
                  color: const Color(0xFFFF8C00),
                  fontSize: screenHeight * 0.06, 
                  fontWeight: FontWeight.bold,
                  shadows: const [
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
      ),
    );
  }
}