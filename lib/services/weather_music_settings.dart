enum TimeRange { morning, afternoon, evening, night }

enum WeatherTrigger { rainy, sunny, cloudy, cold, hot, clear, windy, foggy }

enum SongMood { calm, energetic, happy, sad, focus, relaxed }

class WeatherMusicSettings {
  bool enabled;
  Set<TimeRange> timeRanges;
  Set<WeatherTrigger> weatherTriggers;
  Set<String> languages;
  Set<String> genres;
  Duration autoPlayDuration;
  bool smartNotifications;

  WeatherMusicSettings({
    this.enabled = false,
    Set<TimeRange>? timeRanges,
    Set<WeatherTrigger>? weatherTriggers,
    Set<String>? languages,
    Set<String>? genres,
    Duration? autoPlayDuration,
    this.smartNotifications = false,
  }) : timeRanges =
           timeRanges ??
           {
             TimeRange.morning,
             TimeRange.afternoon,
             TimeRange.evening,
             TimeRange.night,
           },
       weatherTriggers =
           weatherTriggers ??
           {
             WeatherTrigger.rainy,
             WeatherTrigger.sunny,
             WeatherTrigger.cloudy,
             WeatherTrigger.cold,
             WeatherTrigger.hot,
           },
       languages = languages ?? {'English'},
       genres = genres ?? {'lo-fi', 'melody', 'classical'},
       autoPlayDuration = autoPlayDuration ?? const Duration(minutes: 30);

  WeatherMusicSettings copyWith({
    bool? enabled,
    Set<TimeRange>? timeRanges,
    Set<WeatherTrigger>? weatherTriggers,
    Set<String>? languages,
    Set<String>? genres,
    Duration? autoPlayDuration,
    bool? smartNotifications,
  }) {
    return WeatherMusicSettings(
      enabled: enabled ?? this.enabled,
      timeRanges: timeRanges ?? this.timeRanges,
      weatherTriggers: weatherTriggers ?? this.weatherTriggers,
      languages: languages ?? this.languages,
      genres: genres ?? this.genres,
      autoPlayDuration: autoPlayDuration ?? this.autoPlayDuration,
      smartNotifications: smartNotifications ?? this.smartNotifications,
    );
  }
}
