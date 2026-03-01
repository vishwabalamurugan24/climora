import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/weather_service.dart';
import '../services/weather_utils.dart';
import '../services/audio_service.dart';
import '../services/weather_music_settings.dart';
import '../services/recommendation_service.dart';
import '../widgets/climora_bottom_nav.dart';

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
        // live data
      } else {
        final ts = await _service.loadLastWeatherTimestamp();
        if (ts != null) {
          // cached
        } else {
          // mock
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
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        WeatherMusicSettings temp = _settings;
        return StatefulBuilder(
          builder: (context, setSheetState) {
            const Color bgDark = Color(0xFF0F1C1A);
            const Color primaryCream = Color(0xFFEFE6D5);

            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF142925),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customize Weather-based Music',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Preferred Time Ranges:',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF5D7B75),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: TimeRange.values
                          .map(
                            (tr) => ChoiceChip(
                              label: Text(tr.name),
                              selected: temp.timeRanges.contains(tr),
                              selectedColor: primaryCream.withValues(alpha: 0.2),
                              backgroundColor: Colors.white.withValues(alpha: 0.05),
                              labelStyle: GoogleFonts.inter(
                                color: temp.timeRanges.contains(tr)
                                    ? primaryCream
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              showCheckmark: false,
                              side: BorderSide.none,
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
                    const SizedBox(height: 16),
                    Text(
                      'Weather Triggers:',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF5D7B75),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: WeatherTrigger.values
                          .map(
                            (wt) => ChoiceChip(
                              label: Text(wt.name),
                              selected: temp.weatherTriggers.contains(wt),
                              selectedColor: primaryCream.withValues(alpha: 0.2),
                              backgroundColor: Colors.white.withValues(alpha: 0.05),
                              labelStyle: GoogleFonts.inter(
                                color: temp.weatherTriggers.contains(wt)
                                    ? primaryCream
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              showCheckmark: false,
                              side: BorderSide.none,
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
                    const SizedBox(height: 16),
                    Text(
                      'Preferred Languages:',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF5D7B75),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['English', 'Tamil', 'Hindi']
                          .map(
                            (lang) => ChoiceChip(
                              label: Text(lang),
                              selected: temp.languages.contains(lang),
                              selectedColor: primaryCream.withValues(alpha: 0.2),
                              backgroundColor: Colors.white.withValues(alpha: 0.05),
                              labelStyle: GoogleFonts.inter(
                                color: temp.languages.contains(lang)
                                    ? primaryCream
                                    : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              showCheckmark: false,
                              side: BorderSide.none,
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
                    const SizedBox(height: 16),
                    Text(
                      'Music Genres:',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF5D7B75),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          [
                                'lo-fi',
                                'melody',
                                'classical',
                                'energetic',
                                'devotional',
                              ]
                              .map(
                                (g) => ChoiceChip(
                                  label: Text(g),
                                  selected: temp.genres.contains(g),
                                  selectedColor: primaryCream.withValues(alpha: 0.2),
                                  backgroundColor: Colors.white.withValues(alpha: 
                                    0.05,
                                  ),
                                  labelStyle: GoogleFonts.inter(
                                    color: temp.genres.contains(g)
                                        ? primaryCream
                                        : Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  showCheckmark: false,
                                  side: BorderSide.none,
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
                    const SizedBox(height: 16),
                    Text(
                      'Auto-play Duration:',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF5D7B75),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Duration>(
                          value: temp.autoPlayDuration,
                          dropdownColor: const Color(0xFF142925),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: primaryCream,
                          ),
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
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
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      value: temp.smartNotifications,
                      onChanged: (v) => setSheetState(
                        () => temp = temp.copyWith(smartNotifications: v),
                      ),
                      activeThumbColor: primaryCream,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Smart notifications for mood-based suggestions',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(
                            'CANCEL',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF5D7B75),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _settings = temp);
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryCream,
                            foregroundColor: bgDark,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'SAVE',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
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
    const Color bgDark = Color(0xFF0F1C1A);
    const Color primaryCream = Color(0xFFEFE6D5);

    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/home'),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chevron_left_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    Text(
                      'WEATHER INSIGHTS',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showCustomizationPanel(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.settings_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF142925),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primaryCream.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    children: [
                      Switch(
                        value: _settings.enabled,
                        onChanged: (v) => setState(
                          () => _settings = _settings.copyWith(enabled: v),
                        ),
                        activeThumbColor: primaryCream,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _settings.enabled
                              ? 'Weather-based Song Mode is ON'
                              : 'Weather-based Song Mode is OFF',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _load,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryCream.withValues(alpha: 0.1),
                    foregroundColor: primaryCream,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: primaryCream.withValues(alpha: 0.2)),
                    ),
                  ),
                  child: Text(
                    'GET CURRENT WEATHER',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_loading)
                  const Center(
                    child: CircularProgressIndicator(color: primaryCream),
                  ),
                if (_error != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Error: $_error',
                      style: GoogleFonts.inter(color: Colors.redAccent),
                    ),
                  ),
                if (_weather != null) ...[
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF142925),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_weather!.temp}°C',
                                  style: GoogleFonts.inter(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: -2,
                                  ),
                                ),
                                Text(
                                  _weather!.description.toUpperCase(),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: primaryCream,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.cloud_rounded, // fallback icon
                              size: 64,
                              color: primaryCream.withValues(alpha: 0.8),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _WeatherStat(
                              'HUMIDITY',
                              '${_weather!.humidity}%',
                              Icons.water_drop_rounded,
                            ),
                            _WeatherStat(
                              'WIND',
                              '${_weather!.windSpeed}m/s',
                              Icons.air_rounded,
                            ),
                            _WeatherStat(
                              'COMFORT',
                              ClimateIndices.comfortIndex(
                                _weather!.temp,
                                _weather!.humidity,
                                _weather!.windSpeed,
                              ).toString(),
                              Icons.sentiment_satisfied_rounded,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Suggested Ambient Sounds',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _suggestions
                        .map(
                          (s) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: primaryCream.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              s,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: primaryCream,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  if (_currentRecommendation?.songMetadata != null) ...[
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            primaryCream.withValues(alpha: 0.15),
                            primaryCream.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: primaryCream.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome_rounded,
                                color: primaryCream,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'AI RECOMMENDATION',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: primaryCream,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: primaryCream.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.music_note_rounded,
                                color: primaryCream,
                              ),
                            ),
                            title: Text(
                              _currentRecommendation!.songMetadata!.title,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              _currentRecommendation!.songMetadata!.artist,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFF5D7B75),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final meta =
                                    _currentRecommendation!.songMetadata!;
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
                                    SnackBar(
                                      content: Text('Playing ${meta.title}...'),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: const Color(0xFF142925),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryCream,
                                foregroundColor: bgDark,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              icon: const Icon(Icons.play_arrow_rounded),
                              label: Text(
                                'PLAY RECOMMENDED',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _suggestions.isEmpty
                              ? null
                              : () async {
                                  if (!_playing) {
                                    // load assets for suggestions
                                    for (final s in _suggestions) {
                                      final path = 'assets/audio/$s.mp3';
                                      if (!_audio.isLoaded(s)) {
                                        try {
                                          await _audio.loadAsset(
                                            s,
                                            path,
                                            volume: _volumes[s] ?? 0.6,
                                          );
                                        } catch (_) {}
                                      }
                                      await _audio.play(s);
                                    }
                                    setState(() => _playing = true);
                                  } else {
                                    await _audio.stopAll();
                                    setState(() => _playing = false);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _playing
                                ? Colors.redAccent.withValues(alpha: 0.2)
                                : primaryCream.withValues(alpha: 0.1),
                            foregroundColor: _playing
                                ? Colors.redAccent
                                : primaryCream,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            _playing ? 'STOP AMBIENT' : 'PLAY AMBIENT',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            await _audio.stopAll();
                            setState(() => _playing = false);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'STOP ALL',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (_suggestions.isNotEmpty)
                    Text(
                      'Mixer',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  const SizedBox(height: 16),
                  ..._suggestions.map(
                    (s) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF5D7B75),
                          ),
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: primaryCream,
                            inactiveTrackColor: primaryCream.withValues(alpha: 0.1),
                            thumbColor: primaryCream,
                            trackHeight: 4,
                          ),
                          child: Slider(
                            value: _volumes[s] ?? 0.0,
                            min: 0.0,
                            max: 1.0,
                            onChanged: (v) async {
                              setState(() => _volumes[s] = v);
                              if (_audio.isLoaded(s)) {
                                await _audio.setVolume(s, v);
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const ClimoraBottomNav(currentRoute: '/weather'),
        ],
      ),
    );
  }
}

class _WeatherStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _WeatherStat(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    const Color primaryCream = Color(0xFFEFE6D5);

    return Column(
      children: [
        Icon(icon, color: primaryCream.withValues(alpha: 0.5), size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF5D7B75),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
