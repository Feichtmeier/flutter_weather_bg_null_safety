import 'package:flutter/cupertino.dart';

/// Currently there are 15 types of weather
enum WeatherType {
  heavyRainy,
  heavySnow,
  middleSnow,
  thunder,
  lightRainy,
  lightSnow,
  sunnyNight,
  sunny,
  cloudy,
  cloudyNight,
  middleRainy,
  overcast,
  hazy,
  foggy,
  dusty;

  // Get the weather description based on the weather type, defaults to Chinese
  String localize({
    String? sunny,
    String? cloudy,
    String? overcast,
    String? lightRainy,
    String? middleRainy,
    String? heavyRainy,
    String? thunder,
    String? hazy,
    String? foggy,
    String? lightSnow,
    String? middleSnow,
    String? heavySnow,
    String? dusty,
  }) {
    return switch (this) {
      WeatherType.sunny || WeatherType.sunnyNight => sunny ?? '晴',
      WeatherType.cloudy || WeatherType.cloudyNight => cloudy ?? '多云',
      WeatherType.overcast => overcast ?? '阴',
      WeatherType.lightRainy => lightRainy ?? '小雨',
      WeatherType.middleRainy => middleRainy ?? '中雨',
      WeatherType.heavyRainy => heavyRainy ?? '大雨',
      WeatherType.thunder => thunder ?? '雷阵雨',
      WeatherType.hazy => hazy ?? '雾',
      WeatherType.foggy => foggy ?? '霾',
      WeatherType.lightSnow => lightSnow ?? '小雪',
      WeatherType.middleSnow => middleSnow ?? '中雪',
      WeatherType.heavySnow => heavySnow ?? '大雪',
      WeatherType.dusty => dusty ?? '浮尘',
    };
  }
}

/// Data loading state
enum WeatherDataState {
  /// init
  init,

  /// Loading in progress
  loading,

  /// Loading finished
  finish,
}

/// Weather-related utility class
class WeatherUtil {
  static bool isSnowRain(WeatherType weatherType) {
    return isRainy(weatherType) || isSnow(weatherType);
  }

  /// Check if it is raining, including light, moderate, heavy rain, and thunderstorm
  static bool isRainy(WeatherType weatherType) {
    return weatherType == WeatherType.lightRainy ||
        weatherType == WeatherType.middleRainy ||
        weatherType == WeatherType.heavyRainy ||
        weatherType == WeatherType.thunder;
  }

  /// Check if it is snowing
  static bool isSnow(WeatherType weatherType) {
    return weatherType == WeatherType.lightSnow ||
        weatherType == WeatherType.middleSnow ||
        weatherType == WeatherType.heavySnow;
  }

  // Get the background color value based on the weather type
  static List<Color> getColor(WeatherType weatherType) {
    return switch (weatherType) {
      WeatherType.sunny => [const Color(0xFF0071D1), const Color(0xFF6DA6E4)],
      WeatherType.sunnyNight => [
          const Color(0xFF061E74),
          const Color(0xFF275E9A),
        ],
      WeatherType.cloudy => [const Color(0xFF5C82C1), const Color(0xFF95B1DB)],
      WeatherType.cloudyNight => [
          const Color(0xFF2C3A60),
          const Color(0xFF4B6685),
        ],
      WeatherType.overcast => [
          const Color(0xFF8FA3C0),
          const Color(0xFF8C9FB1),
        ],
      WeatherType.lightRainy => [
          const Color(0xFF556782),
          const Color(0xFF7c8b99),
        ],
      WeatherType.middleRainy => [
          const Color(0xFF3A4B65),
          const Color(0xFF495764),
        ],
      WeatherType.heavyRainy || WeatherType.thunder => [
          const Color(0xFF3B434E),
          const Color(0xFF565D66),
        ],
      WeatherType.hazy => [const Color(0xFF989898), const Color(0xFF4B4B4B)],
      WeatherType.foggy => [const Color(0xFFA6B3C2), const Color(0xFF737F88)],
      WeatherType.lightSnow => [
          const Color(0xFF6989BA),
          const Color(0xFF9DB0CE),
        ],
      WeatherType.middleSnow => [
          const Color(0xFF8595AD),
          const Color(0xFF95A4BF),
        ],
      WeatherType.heavySnow => [
          const Color(0xFF98A2BC),
          const Color(0xFFA7ADBF),
        ],
      WeatherType.dusty => [const Color(0xFFB99D79), const Color(0xFF6C5635)],
    };
  }
}
