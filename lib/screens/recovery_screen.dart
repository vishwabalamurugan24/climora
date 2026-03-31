import 'package:flutter/material.dart';
import 'package:climora/core/theme/app_theme.dart';
import '../widgets/climora_bottom_nav.dart';

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key});

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breatheAnimation;
  String _instruction = 'Prepare';

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _breatheAnimation = Tween<double>(begin: 0.8, end: 1.25).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );

    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _instruction = 'Exhale');
        _breathingController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() => _instruction = 'Inhale');
        _breathingController.forward();
      }
    });

    _breathingController.forward();
  }

  @override
  void dispose() {
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Dynamic Background
          AnimatedBuilder(
            animation: _breathingController,
            builder: (context, _) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color.lerp(
                        const Color(0xFF1a2a6c),
                        const Color(0xFFb21f1f),
                        _breathingController.value,
                      )!,
                      Colors.black,
                    ],
                    radius: 1.5,
                  ),
                ),
              );
            },
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  'INSTANT RECOVERY',
                  style: TextStyle(
                    letterSpacing: 8,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),

                // Pulsing Breathing Circle
                AnimatedBuilder(
                  animation: _breatheAnimation,
                  builder: (context, _) {
                    return Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer Rings
                          for (int i = 0; i < 3; i++)
                            Transform.scale(
                              scale: _breatheAnimation.value + (i * 0.1),
                              child: Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),

                          // Main Breathing Sphere
                          Container(
                            width: 180 * _breatheAnimation.value,
                            height: 180 * _breatheAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF4A00E0,
                                  ).withValues(alpha: 0.5),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                          ),

                          Text(
                            _instruction,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: AppTheme.glassBox(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Follow the rhythm of the sphere to stabilize your heart rate.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => Navigator.pushReplacementNamed(
                              context,
                              '/home',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white10,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Exit Recovery Mode'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          if (_instruction == 'Prepare')
            Positioned(
              left: 0,
              right: 0,
              bottom: 120,
              child: Center(
                child: Hero(
                  tag: 'orb',
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Bottom Nav Bar
          const ClimoraBottomNav(currentRoute: '/recovery'),
        ],
      ),
    );
  }
}
