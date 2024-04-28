import 'package:flutter/material.dart';
import 'weather_cloud_bg.dart';
import 'weather_color_bg.dart';
import 'weather_night_star_bg.dart';
import 'weather_rain_snow_bg.dart';
import 'weather_thunder_bg.dart';
import '../utils/weather_type.dart';

/// The core class that combines background, thunder, rain/snow, night star, and meteor effects.
/// 1. Supports dynamic size switching.
/// 2. Supports smooth transitions.
class WeatherBg extends StatefulWidget {
  final WeatherType weatherType;
  final double width;
  final double height;

  const WeatherBg({
    super.key,
    required this.weatherType,
    required this.width,
    required this.height,
  });

  @override
  State<WeatherBg> createState() => _WeatherBgState();
}

class _WeatherBgState extends State<WeatherBg>
    with SingleTickerProviderStateMixin {
  WeatherType? _oldWeatherType;
  bool needChange = false;
  var state = CrossFadeState.showSecond;

  @override
  void didUpdateWidget(WeatherBg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.weatherType != oldWidget.weatherType) {
      // If the category changes, start the fade animation
      _oldWeatherType = oldWidget.weatherType;
      needChange = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    WeatherItemBg? oldBgWidget;
    if (_oldWeatherType != null) {
      oldBgWidget = WeatherItemBg(
        weatherType: _oldWeatherType!,
        width: widget.width,
        height: widget.height,
      );
    }
    var currentBgWidget = WeatherItemBg(
      weatherType: widget.weatherType,
      width: widget.width,
      height: widget.height,
    );
    oldBgWidget ??= currentBgWidget;
    var firstWidget = currentBgWidget;
    var secondWidget = currentBgWidget;
    if (needChange) {
      if (state == CrossFadeState.showSecond) {
        state = CrossFadeState.showFirst;
        firstWidget = currentBgWidget;
        secondWidget = oldBgWidget;
      } else {
        state = CrossFadeState.showSecond;
        secondWidget = currentBgWidget;
        firstWidget = oldBgWidget;
      }
    }
    needChange = false;
    return SizeInherited(
      size: Size(widget.width, widget.height),
      child: AnimatedCrossFade(
        firstChild: firstWidget,
        secondChild: secondWidget,
        duration: const Duration(milliseconds: 300),
        crossFadeState: state,
      ),
    );
  }
}

class WeatherItemBg extends StatelessWidget {
  final WeatherType weatherType;
  final double width;
  final double height;

  const WeatherItemBg({
    super.key,
    required this.weatherType,
    required this.width,
    required this.height,
  });

  /// Build the background effect for clear night
  Widget _buildNightStarBg() {
    if (weatherType == WeatherType.sunnyNight) {
      return WeatherNightStarBg(
        weatherType: weatherType,
      );
    }
    return Container();
  }

  /// Build the thunder effect
  Widget _buildThunderBg() {
    if (weatherType == WeatherType.thunder) {
      return WeatherThunderBg(
        weatherType: weatherType,
      );
    }
    return Container();
  }

  /// Build the rain and snow background effect
  Widget _buildRainSnowBg() {
    if (WeatherUtil.isSnowRain(weatherType)) {
      return WeatherRainSnowBg(
        weatherType: weatherType,
        viewWidth: width,
        viewHeight: height,
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRect(
        child: Stack(
          children: [
            WeatherColorBg(
              weatherType: weatherType,
            ),
            WeatherCloudBg(
              weatherType: weatherType,
            ),
            _buildRainSnowBg(),
            _buildThunderBg(),
            _buildNightStarBg(),
          ],
        ),
      ),
    );
  }
}

class SizeInherited extends InheritedWidget {
  final Size size;

  const SizeInherited({
    super.key,
    required super.child,
    required this.size,
  });

  static SizeInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SizeInherited>();
  }

  @override
  bool updateShouldNotify(SizeInherited oldWidget) {
    return oldWidget.size != size;
  }
}
