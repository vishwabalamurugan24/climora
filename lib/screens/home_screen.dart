import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_theme_provider.dart';
import '../services/climora_weather_api.dart'; // Using the newly isolated API client
import '../widgets/animated_weather_background.dart';
import '../widgets/weather_glass_card.dart';
import '../theme/weather_theme.dart';
import '../models/weather_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ClimoraWeatherApi _weatherService = ClimoraWeatherApi(
    apiKey: 'YOUR_OPENWEATHER_API_KEY', // Replace with your API key
  );
  
  bool _isLoading = true;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }
  
  Future<void> _fetchWeather() async {
    try {
      final weather = await _weatherService.fetchWeather('London'); // Use user's location
      Provider.of<WeatherThemeProvider>(context, listen: false).updateThemeWithCache(weather);
      
      setState(() {
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<WeatherThemeProvider>(context);
    final currentTheme = themeProvider.currentTheme;
    final weather = themeProvider.currentWeather;
    
    return AnimatedWeatherBackground(
      theme: currentTheme,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Climora',
            style: TextStyle(
              color: currentTheme.textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: currentTheme.textColor),
              onPressed: () {
                setState(() {
                  _isLoading = true;
                });
                _fetchWeather();
              },
            ),
          ],
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(currentTheme.accentColor),
                ),
              )
            : _error != null
                ? Center(
                    child: WeatherGlassCard(
                      theme: currentTheme,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: currentTheme.accentColor),
                          SizedBox(height: 16),
                          Text(
                            'Error: $_error\n\nPlease add a valid API key in lib/screens/home_screen.dart',
                            style: TextStyle(color: currentTheme.textColor),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              _fetchWeather();
                            },
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                : _buildMainContent(context, currentTheme, weather),
      ),
    );
  }
  
  Widget _buildMainContent(BuildContext context, WeatherTheme theme, WeatherModel? weather) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Weather Info Card
          WeatherGlassCard(
            theme: theme,
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  weather?.cityName ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.textColor,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '${weather?.temperature.toStringAsFixed(1) ?? '--'}°C',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: theme.textColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  weather?.condition.toUpperCase() ?? '--',
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.textColor.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildWeatherDetail(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '${weather?.humidity ?? '--'}%',
                      theme: theme,
                    ),
                    _buildWeatherDetail(
                      icon: Icons.air,
                      label: 'Wind',
                      value: '${weather?.windSpeed.toStringAsFixed(1) ?? '--'} m/s',
                      theme: theme,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Music Player Preview
          WeatherGlassCard(
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Music for ${theme.name} Weather',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textColor,
                  ),
                ),
                SizedBox(height: 12),
                ListTile(
                  leading: Icon(Icons.music_note, color: theme.accentColor),
                  title: Text(
                    'Chill Vibes',
                    style: TextStyle(color: theme.textColor),
                  ),
                  subtitle: Text(
                    'Perfect for ${theme.name.toLowerCase()} days',
                    style: TextStyle(color: theme.textColor.withOpacity(0.7)),
                  ),
                  trailing: Icon(Icons.play_circle, color: theme.accentColor),
                ),
                ListTile(
                  leading: Icon(Icons.music_note, color: theme.accentColor),
                  title: Text(
                    'Ambient Sounds',
                    style: TextStyle(color: theme.textColor),
                  ),
                  subtitle: Text(
                    'Relaxing background music',
                    style: TextStyle(color: theme.textColor.withOpacity(0.7)),
                  ),
                  trailing: Icon(Icons.play_circle, color: theme.accentColor),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Place Recommendations
          WeatherGlassCard(
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommended Places',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.textColor,
                  ),
                ),
                SizedBox(height: 12),
                _buildPlaceRecommendation(
                  name: 'Cozy Café',
                  description: 'Perfect spot for ${theme.name.toLowerCase()} weather',
                  icon: Icons.local_cafe,
                  theme: theme,
                ),
                Divider(color: theme.textColor.withOpacity(0.2)),
                _buildPlaceRecommendation(
                  name: 'Indoor Garden',
                  description: 'Escape the ${theme.name.toLowerCase()} weather',
                  icon: Icons.yard, // Changed from Icons.garden since yard or similar is more commonly available
                  theme: theme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWeatherDetail({
    required IconData icon,
    required String label,
    required String value,
    required WeatherTheme theme,
  }) {
    return Column(
      children: [
        Icon(icon, color: theme.accentColor, size: 28),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.textColor.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.textColor,
          ),
        ),
      ],
    );
  }
  
  Widget _buildPlaceRecommendation({
    required String name,
    required String description,
    required IconData icon,
    required WeatherTheme theme,
  }) {
    return ListTile(
      leading: Icon(icon, color: theme.accentColor),
      title: Text(
        name,
        style: TextStyle(color: theme.textColor),
      ),
      subtitle: Text(
        description,
        style: TextStyle(color: theme.textColor.withOpacity(0.7)),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: theme.accentColor, size: 16),
    );
  }
}
