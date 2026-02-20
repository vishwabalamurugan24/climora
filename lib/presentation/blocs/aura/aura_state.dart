import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class AuraState extends Equatable {
  final List<Color> colors;
  const AuraState(this.colors);

  @override
  List<Object> get props => [colors];
}

class AuraInitial extends AuraState {
  const AuraInitial()
    : super(const [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)]);
}

class AuraUpdated extends AuraState {
  const AuraUpdated(super.colors);
}
