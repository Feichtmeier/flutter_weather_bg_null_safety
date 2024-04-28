import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';

/// Provides two main instances.
/// 1. There will be a transition animation when switching weather types.
/// 2. Changing the width and height dynamically will also affect the related drawing logic.
class AnimViewWidget extends StatefulWidget {
  const AnimViewWidget({super.key});

  @override
  State<AnimViewWidget> createState() => _AnimViewWidgetState();
}

class _AnimViewWidgetState extends State<AnimViewWidget> {
  WeatherType _weatherType = WeatherType.sunny;
  double _width = 100;
  double _height = 200;

  @override
  Widget build(BuildContext context) {
    var radius = 5 + (_width - 100) / 200 * 10;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimView'),
        actions: [
          PopupMenuButton<WeatherType>(
            itemBuilder: (context) {
              return <PopupMenuEntry<WeatherType>>[
                ...WeatherType.values.map(
                  (e) => PopupMenuItem<WeatherType>(
                    value: e,
                    child: Text(_weatherType.localize()),
                  ),
                ),
              ];
            },
            initialValue: _weatherType,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_weatherType.localize()),
                const Icon(Icons.more_vert),
              ],
            ),
            onSelected: (count) {
              setState(() {
                _weatherType = count;
              });
            },
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 7,
            margin: const EdgeInsets.only(top: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            child: ClipPath(
              clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
              ),
              child: WeatherBg(
                weatherType: _weatherType,
                width: _width,
                height: _height,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          Slider(
            min: 100,
            max: 300,
            label: '$_width',
            divisions: 200,
            onChanged: (value) {
              setState(() {
                _width = value;
              });
            },
            value: _width,
          ),
          const SizedBox(
            height: 20,
          ),
          Slider(
            min: 200,
            max: 600,
            label: '$_height',
            divisions: 400,
            onChanged: (value) {
              setState(() {
                _height = value;
              });
            },
            value: _height,
          ),
        ],
      ),
    );
  }
}
