import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'core/theme/app_theme.dart';
import 'presentation/widgets/aura_background.dart';
import 'presentation/widgets/voice_orb.dart';
import 'screens/weather_screen.dart';
import 'screens/navigation_screen.dart';
import 'screens/recovery_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/map_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/playlist_screen.dart';
import 'screens/player_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'widgets/assistant_overlay.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/blocs/aura/aura_bloc.dart';
import 'presentation/blocs/aura/aura_event.dart';
import 'presentation/blocs/aura/aura_state.dart';
import 'services/weather_service.dart';

void main() {
  runApp(
    BlocProvider(create: (context) => AuraBloc(), child: const ClimoraApp()),
  );
}

class ClimoraApp extends StatelessWidget {
  const ClimoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      builder: (context, child) {
        return AssistantOverlay(child: child!);
      },
      home: const LoginScreen(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/home': (_) => const HomeScreen(),
        '/aura_home': (_) => const ClimoraHomeScreen(),
        '/weather': (_) => const WeatherScreen(),
        '/navigation': (_) => const NavigationScreen(),
        '/recovery': (_) => const RecoveryScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/map': (_) => const MapScreen(),
        '/explore': (_) => const ExploreScreen(),
        '/playlist': (_) => const PlaylistScreen(),
        '/player': (_) => const PlayerScreen(),
      },
    );
  }
}

class ClimoraHomeScreen extends StatefulWidget {
  const ClimoraHomeScreen({super.key});

  @override
  State<ClimoraHomeScreen> createState() => _ClimoraHomeScreenState();
}

class _ClimoraHomeScreenState extends State<ClimoraHomeScreen> {
  bool _isListening = false;
  double _voiceVolume = 0.0;
  final WeatherService _weatherService = WeatherService();

  @override
  void initState() {
    super.initState();
    _fetchInitialContext();
  }

  Future<void> _fetchInitialContext() async {
    final weather = await _weatherService.getWeatherForCurrentLocation(
      allowMock: true,
    );
    if (weather != null && mounted) {
      context.read<AuraBloc>().add(
        ContextChanged(weatherDescription: weather.description),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuraBloc, AuraState>(
      builder: (context, auraState) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text(
              'CLIMORA',
              style: TextStyle(letterSpacing: 8, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.analytics_outlined),
                onPressed: () {},
              ),
            ],
          ),
          body: AuraBackground(
            colors: auraState.colors,
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Symphony of Context',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white60,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),

                  // Central Voice Activation Orb
                  GestureDetector(
                    onTap: () {
                      setState(() => _isListening = !_isListening);
                      if (_isListening) {
                        _simulateVoice();
                      }
                    },
                    child: VoiceOrb(
                      isListening: _isListening,
                      volume: _voiceVolume,
                    ),
                  ),

                  const Spacer(),

                  // Action Cards (Dashboard)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildGlassAction(
                                context,
                                title: 'Weather',
                                icon: Icons.cloud_outlined,
                                route: '/weather',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildGlassAction(
                                context,
                                title: 'Explore',
                                icon: Icons.explore_outlined,
                                route: '/explore',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildFullWidthAction(
                          context,
                          title: 'Nearby Discoveries',
                          subtitle: 'Find your perfect mood spot',
                          icon: Icons.map_outlined,
                          route: '/navigation',
                        ),
                        const SizedBox(height: 16),
                        _buildFullWidthAction(
                          context,
                          title: 'Instant Recovery Mode',
                          subtitle: 'Stabilize your state immediately',
                          icon: Icons.flash_on_outlined,
                          route: '/recovery',
                          isAction: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _simulateVoice() async {
    while (_isListening) {
      if (!mounted) {
        break;
      }
      setState(() => _voiceVolume = math.Random().nextDouble());
      await Future.delayed(const Duration(milliseconds: 300));
    }
    if (mounted) {
      setState(() => _voiceVolume = 0.0);
    }
  }

  Widget _buildGlassAction(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
  }) {
    return AppTheme.glassBox(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => Navigator.pushNamed(context, route),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Icon(icon, size: 32, color: Colors.blue[300]),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullWidthAction(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String route,
    bool isAction = false,
  }) {
    return AppTheme.glassBox(
      child: Material(
        color: isAction
            ? Colors.red.withValues(alpha: 0.1)
            : Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => Navigator.pushNamed(context, route),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 28,
                  color: isAction ? Colors.redAccent : Colors.blue[300],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isAction ? Colors.redAccent : Colors.white,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
