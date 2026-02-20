import 'package:equatable/equatable.dart';

abstract class AuraEvent extends Equatable {
  const AuraEvent();

  @override
  List<Object> get props => [];
}

class ContextChanged extends AuraEvent {
  final String? weatherDescription;
  final String? emotionLabel;

  const ContextChanged({this.weatherDescription, this.emotionLabel});

  @override
  List<Object> get props => [weatherDescription ?? '', emotionLabel ?? ''];
}
