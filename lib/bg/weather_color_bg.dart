import 'package:flutter/material.dart';
import '../utils/weather_type.dart';

/// Color background layer
class WeatherColorBg extends StatelessWidget {
  final WeatherType weatherType;

  /// Controls the height of the background.
  final double? height;

  const WeatherColorBg({super.key, required this.weatherType, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: WeatherUtil.getColor(weatherType),
          stops: const [0, 1],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
