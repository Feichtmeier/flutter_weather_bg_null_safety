import 'package:flutter/widgets.dart';

/// Define the print function
typedef WeatherPrint = void Function(
  String message, {
  int wrapWidth,
  String tag,
});

const kWeatherDebug = false;

WeatherPrint weatherPrint = debugPrintThrottled;

// Unified method for printing
void debugPrintThrottled(String message, {int? wrapWidth, String? tag}) {
  if (kWeatherDebug) {
    debugPrint('flutter-weather: $tag: $message', wrapWidth: wrapWidth);
  }
}
