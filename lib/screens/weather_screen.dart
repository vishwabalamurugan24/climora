import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../services/weather_utils.dart';
import '../services/audio_service.dart';
import '../services/weather_music_settings.dart';
import '../services/recommendation_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _service = WeatherService();
  WeatherData? _weather;
  List<String> _suggestions = [];
  String? _error;
  bool _loading = false;
  final AudioService _audio = AudioService();
  bool _playing = false;
  final Map<String, double> _volumes = {};
  DateTime? _lastUpdated;
  String _dataSource = 'unknown'; // 'live', 'cached', 'mock'

  WeatherMusicSettings _settings = WeatherMusicSettings();
  final RecommendationService _recoService = RecommendationService();
  Recommendation? _currentRecommendation;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Try to get live data (or cached/mock fallback inside service)
      final w = await _service.getWeatherForCurrentLocation(allowMock: true);
      if (w == null) throw Exception('No weather available');
      // determine source: if API key present, assume live; otherwise check cached timestamp
      if (_service.hasApiKey) {
        _dataSource = 'live';
        _lastUpdated = await _service.loadLastWeatherTimestamp();
      } else {
        final ts = await _service.loadLastWeatherTimestamp();
        if (ts != null) {
          _dataSource = 'cached';
          _lastUpdated = ts;
        } else {
          _dataSource = 'mock';
        }
      }
      final suggestions = ClimateIndices.suggestAmbientSounds(w);
      final recommendations = _recoService.recommend(
        weather: w,
        settings: _settings,
      );

      setState(() {
        _weather = w;
        _suggestions = suggestions;
        _currentRecommendation = recommendations;
        _volumes.clear();
        for (final s in suggestions) {
          _volumes[s] = 0.6;
        }
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _showCustomizationPanel(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        WeatherMusicSettings temp = _settings;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Customize Weather-based Music',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text('Preferred Time Ranges:'),
                    Wrap(
                      spacing: 8,
                      children: TimeRange.values
                          .map(
                            (tr) => FilterChip(
                              label: Text(tr.name),
                              selected: temp.timeRanges.contains(tr),
                              onSelected: (v) => setSheetState(
                                () => temp = temp.copyWith(
                                  timeRanges:
                                      v
                                            ? {...temp.timeRanges, tr}
                                            : {...temp.timeRanges}
                                        ..remove(tr),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    const Text('Weather Triggers:'),
                    Wrap(
                      spacing: 8,
                      children: WeatherTrigger.values
                          .map(
                            (wt) => FilterChip(
                              label: Text(wt.name),
                              selected: temp.weatherTriggers.contains(wt),
                              onSelected: (v) => setSheetState(
                                () => temp = temp.copyWith(
                                  weatherTriggers:
                                      v
                                            ? {...temp.weatherTriggers, wt}
                                            : {...temp.weatherTriggers}
                                        ..remove(wt),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    const Text('Preferred Languages:'),
                    Wrap(
                      spacing: 8,
                      children: ['English', 'Tamil', 'Hindi']
                          .map(
                            (lang) => FilterChip(
                              label: Text(lang),
                              selected: temp.languages.contains(lang),
                              onSelected: (v) => setSheetState(
                                () => temp = temp.copyWith(
                                  languages:
                                      v
                                            ? {...temp.languages, lang}
                                            : {...temp.languages}
                                        ..remove(lang),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    const Text('Music Genres:'),
                    Wrap(
                      spacing: 8,
                      children:
                          [
                                'lo-fi',
                                'melody',
                                'classical',
                                'energetic',
                                'devotional',
                              ]
                              .map(
                                (g) => FilterChip(
                                  label: Text(g),
                                  selected: temp.genres.contains(g),
                                  onSelected: (v) => setSheetState(
                                    () => temp = temp.copyWith(
                                      genres:
                                          v
                                                ? {...temp.genres, g}
                                                : {...temp.genres}
                                            ..remove(g),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 12),
                    const Text('Auto-play Duration:'),
                    DropdownButton<Duration>(
                      value: temp.autoPlayDuration,
                      items:
                          [
                                const Duration(minutes: 15),
                                const Duration(minutes: 30),
                                const Duration(hours: 1),
                              ]
                              .map(
                                (d) => DropdownMenuItem(
                                  value: d,
                                  child: Text(
                                    d.inMinutes >= 60
                                        ? '${d.inHours} hour'
                                        : '${d.inMinutes} min',
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (d) => setSheetState(
                        () => temp = temp.copyWith(autoPlayDuration: d),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      value: temp.smartNotifications,
                      onChanged: (v) => setSheetState(
                        () => temp = temp.copyWith(smartNotifications: v),
                      ),
                      title: const Text(
                        'Enable smart notifications for mood-based suggestions',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _settings = temp);
                            Navigator.pop(ctx);
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              children: [
                Switch(
                  value: _settings.enabled,
                  onChanged: (v) => setState(
                    () => _settings = _settings.copyWith(enabled: v),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _settings.enabled
                      ? 'Weather-based Song Mode: ON'
                      : 'Weather-based Song Mode: OFF',
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.settings),
                  tooltip: 'Customize',
                  onPressed: () => _showCustomizationPanel(context),
                ),
              ],
            ),
            const Divider(),
            ElevatedButton(
              onPressed: _load,
              child: const Text('Get current weather'),
            ),
            const SizedBox(height: 16),
            if (_loading) const Center(child: CircularProgressIndicator()),
            if (_error != null)
              Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            if (_weather != null) ...[
              if (_lastUpdated != null)
                Text('Last updated: ${_lastUpdated!.toLocal()} ($_dataSource)'),
              if (_lastUpdated == null) Text('Source: $_dataSource'),
              Text('Temperature: ${_weather!.temp} °C'),
              Text('Humidity: ${_weather!.humidity}%'),
              Text('Wind speed: ${_weather!.windSpeed} m/s'),
              Text('Cloudiness: ${_weather!.cloudiness}%'),
              Text('Description: ${_weather!.description}'),
              Text('Precipitation (mm): ${_weather!.precipitation ?? 0}'),
              const SizedBox(height: 12),
              Text(
                'Comfort index: ${ClimateIndices.comfortIndex(_weather!.temp, _weather!.humidity, _weather!.windSpeed)}',
              ),
              const SizedBox(height: 8),
              Text('Suggested ambient sounds:'),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: _suggestions
                    .map((s) => Chip(label: Text(s)))
                    .toList(),
              ),
              const SizedBox(height: 12),
              if (_currentRecommendation?.songMetadata != null) ...[
                const Divider(),
                const Text(
                  'Recommended Song:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.music_note, color: Colors.blue),
                  title: Text(_currentRecommendation!.songMetadata!.title),
                  subtitle: Text(_currentRecommendation!.songMetadata!.artist),
                  trailing: Wrap(
                    spacing: 4,
                    children: _currentRecommendation!.songMetadata!.genres
                        .map(
                          (g) => Chip(
                            label: Text(
                              g,
                              style: const TextStyle(fontSize: 10),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        )
                        .toList(),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final meta = _currentRecommendation!.songMetadata!;
                    if (!_audio.isLoaded(meta.id)) {
                      await _audio.loadAsset(
                        meta.id,
                        meta.assetPath,
                        volume: _currentRecommendation!.volume,
                      );
                    }
                    await _audio.setSpeed(
                      meta.id,
                      _currentRecommendation!.speed,
                    );
                    await _audio.play(meta.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Playing ${meta.title}...')),
                      );
                    }
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play Recommended'),
                ),
                const Divider(),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _suggestions.isEmpty
                        ? null
                        : () async {
                            if (!_playing) {
                              // load assets for suggestions (user should place matching files in assets/audio/)
                              for (final s in _suggestions) {
                                final path = 'assets/audio/$s.mp3';
                                if (!_audio.isLoaded(s)) {
                                  try {
                                    await _audio.loadAsset(
                                      s,
                                      path,
                                      volume: _volumes[s] ?? 0.6,
                                    );
                                  } catch (_) {
                                    // ignore missing assets for now
                                  }
                                }
                                await _audio.play(s);
                              }
                              setState(() {
                                _playing = true;
                              });
                            } else {
                              await _audio.stopAll();
                              setState(() {
                                _playing = false;
                              });
                            }
                          },
                    child: Text(
                      _playing ? 'Stop Ambient Mix' : 'Play Ambient Mix',
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      await _audio.stopAll();
                      setState(() {
                        _playing = false;
                      });
                    },
                    child: const Text('Stop All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._suggestions.map(
                (s) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s),
                    Slider(
                      value: _volumes[s] ?? 0.0,
                      min: 0.0,
                      max: 1.0,
                      divisions: 20,
                      onChanged: (v) async {
                        setState(() {
                          _volumes[s] = v;
                        });
                        if (_audio.isLoaded(s)) {
                          await _audio.setVolume(s, v);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
