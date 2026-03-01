import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:climora/presentation/blocs/aura/aura_event.dart';
import 'package:climora/presentation/blocs/aura/aura_state.dart';
import 'package:climora/services/cloud_data_service.dart';

class AuraBloc extends Bloc<AuraEvent, AuraState> {
  final CloudDataService _cloudDataService;

  AuraBloc({required CloudDataService cloudDataService})
    : _cloudDataService = cloudDataService,
      super(const AuraInitial()) {
    on<ContextChanged>(_onContextChanged);
    on<SyncToCloud>(_onSyncToCloud);
  }

  void _onContextChanged(ContextChanged event, Emitter<AuraState> emit) {
    List<Color> newColors = const [
      Color(0xFF0F2027),
      Color(0xFF203A43),
      Color(0xFF2C5364),
    ]; // Default deep night

    final desc = event.weatherDescription?.toLowerCase() ?? '';
    final emotion = event.emotionLabel?.toLowerCase() ?? '';

    // Logic to select aura colors
    if (desc.contains('rain')) {
      newColors = [
        const Color(0xFF1e3c72),
        const Color(0xFF2a5298),
      ]; // Rainy Blue
    } else if (desc.contains('clear') || desc.contains('sun')) {
      newColors = [
        const Color(0xFFf8ff00),
        const Color(0xFF3ad59f),
      ]; // Sunny Teal
    }

    if (emotion.contains('happy')) {
      newColors = [
        const Color(0xFFFF5F6D),
        const Color(0xFFFFC371),
      ]; // Happy Peach
    } else if (emotion.contains('stress')) {
      newColors = [
        const Color(0xFF2C3E50),
        const Color(0xFFFD746C),
      ]; // Stress Relief Deep Red
    }

    emit(AuraUpdated(newColors));
  }

  Future<void> _onSyncToCloud(
    SyncToCloud event,
    Emitter<AuraState> emit,
  ) async {
    try {
      if (event.vibe != null) {
        await _cloudDataService.logMood(
          userId: event.userId,
          vibe: event.vibe!,
        );
      }
      if (event.lat != null && event.lon != null) {
        await _cloudDataService.logLocation(
          userId: event.userId,
          latitude: event.lat!,
          longitude: event.lon!,
        );
      }
      if (event.weatherCondition != null && event.temperature != null) {
        await _cloudDataService.logWeather(
          userId: event.userId,
          condition: event.weatherCondition!,
          temperature: event.temperature!,
        );
      }
    } catch (e) {
      debugPrint('Cloud sync failed: $e');
    }
  }
}
