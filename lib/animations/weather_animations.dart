import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherAnimations {
  static Widget sunnyAnimation() {
    return Lottie.asset('assets/animations/sunny.json');
  }

  static Widget rainyAnimation() {
    return Lottie.asset('assets/animations/rainy.json');
  }

  static Widget snowyAnimation() {
    return Lottie.asset('assets/animations/snowy.json');
  }

  static Widget cloudyAnimation() {
    return Lottie.asset('assets/animations/cloudy.json');
  }
}
