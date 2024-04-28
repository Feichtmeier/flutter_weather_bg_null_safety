import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';

/// Displays various weather effects in a grid format.
/// Supports switching the number of columns.
class GridViewWidget extends StatefulWidget {
  const GridViewWidget({super.key});

  @override
  State<GridViewWidget> createState() => _GridViewWidgetState();
}

class _GridViewWidgetState extends State<GridViewWidget> {
  int _count = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GridView'),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) {
              return <PopupMenuEntry<int>>[
                ...[
                  1,
                  2,
                  3,
                  4,
                  5,
                ].map(
                  (e) => PopupMenuItem<int>(
                    value: e,
                    child: Text('$e'),
                  ),
                ),
              ];
            },
            onSelected: (count) {
              setState(() {
                _count = count;
              });
            },
          ),
        ],
      ),
      body: GridView.count(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        crossAxisCount: _count,
        childAspectRatio: 1 / 2,
        children: WeatherType.values
            .map(
              (e) => GridItemWidget(
                weatherType: e,
                count: _count,
              ),
            )
            .toList(),
      ),
    );
  }
}

class GridItemWidget extends StatelessWidget {
  final WeatherType weatherType;
  final int count;

  const GridItemWidget({
    super.key,
    required this.weatherType,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    var radius = 20.0 - 2 * count;
    var margin = 10.0 - count;
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(margin),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Stack(
          children: [
            WeatherBg(
              weatherType: weatherType,
              width: MediaQuery.of(context).size.width / count,
              height: MediaQuery.of(context).size.width * 2,
            ),
            Center(
              child: Text(
                weatherType.localize(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30 / count,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
