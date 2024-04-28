import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../flutter_weather_bg.dart';

/// Sunny night & meteor layer
class WeatherNightStarBg extends StatefulWidget {
  final WeatherType weatherType;

  const WeatherNightStarBg({super.key, required this.weatherType});

  @override
  State<WeatherNightStarBg> createState() => _WeatherNightStarBgState();
}

class _WeatherNightStarBgState extends State<WeatherNightStarBg>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_StarParam> _starParams = [];
  final List<_MeteorParam> _meteorParams = [];
  WeatherDataState _state = WeatherDataState.init;
  late double width;
  late double height;
  late double widthRatio;

  /// Prepare star parameters
  void fetchData() async {
    Size? size = SizeInherited.of(context)?.size;
    width = size?.width ?? double.infinity;
    height = size?.height ?? double.infinity;
    widthRatio = width / 392.0;
    _state = WeatherDataState.loading;
    initStarParams();
    setState(() {
      _controller.repeat();
    });
    _state = WeatherDataState.finish;
  }

  /// Initialize star parameters
  void initStarParams() {
    for (int i = 0; i < 100; i++) {
      var index = Random().nextInt(2);
      _StarParam starParam = _StarParam(index);
      starParam.init(width, height, widthRatio);
      _starParams.add(starParam);
    }
    for (int i = 0; i < 4; i++) {
      _MeteorParam param = _MeteorParam();
      param.init(width, height, widthRatio);
      _meteorParams.add(param);
    }
  }

  @override
  void initState() {
    /// Initialize animation information
    _controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildWidget() {
    if (_starParams.isNotEmpty &&
        widget.weatherType == WeatherType.sunnyNight) {
      return CustomPaint(
        painter:
            _StarPainter(_starParams, _meteorParams, width, height, widthRatio),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_state == WeatherDataState.init) {
      fetchData();
    } else if (_state == WeatherDataState.finish) {
      return _buildWidget();
    }
    return Container();
  }
}

class _StarPainter extends CustomPainter {
  final _paint = Paint();
  final _meteorPaint = Paint();
  final List<_StarParam> _starParams;

  final double width;
  final double height;
  final double widthRatio;

  /// Configure star data information
  final List<_MeteorParam> _meteorParams;

  /// Meteor parameter information
  final double _meteorWidth = 200;

  /// Length of the meteor
  final double _meteorHeight = 2;

  /// Height of the meteor
  final Radius _radius = const Radius.circular(10);

  /// Radius of the meteor's rounded corners
  _StarPainter(
    this._starParams,
    this._meteorParams,
    this.width,
    this.height,
    this.widthRatio,
  ) {
    _paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 1);
    _paint.color = Colors.white;
    _paint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_starParams.isNotEmpty) {
      for (var param in _starParams) {
        drawStar(param, canvas);
      }
    }
    if (_meteorParams.isNotEmpty) {
      for (var param in _meteorParams) {
        drawMeteor(param, canvas);
      }
    }
  }

  /// Draw a meteor
  void drawMeteor(_MeteorParam param, Canvas canvas) {
    canvas.save();
    var gradient = ui.Gradient.linear(
      const Offset(0, 0),
      Offset(_meteorWidth, 0),
      <Color>[const Color(0xFFFFFFFF), const Color(0x00FFFFFF)],
    );
    _meteorPaint.shader = gradient;
    canvas.rotate(pi * param.radians);
    canvas.scale(widthRatio);
    canvas.translate(
      param.translateX,
      tan(pi * 0.1) * _meteorWidth + param.translateY,
    );
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        0,
        0,
        _meteorWidth,
        _meteorHeight,
        topLeft: _radius,
        topRight: _radius,
        bottomRight: _radius,
        bottomLeft: _radius,
      ),
      _meteorPaint,
    );
    param.move();
    canvas.restore();
  }

  /// Draw stars
  void drawStar(_StarParam param, Canvas canvas) {
    canvas.save();
    var identity = ColorFilter.matrix(<double>[
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
      0,
      0,
      0,
      0,
      param.alpha,
      0,
    ]);
    _paint.colorFilter = identity;
    canvas.scale(param.scale);
    canvas.drawCircle(Offset(param.x, param.y), 3, _paint);
    canvas.restore();
    param.move();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _MeteorParam {
  late double translateX;
  late double translateY;
  late double radians;

  late double width, height, widthRatio;

  /// Initialize data
  void init(width, height, widthRatio) {
    this.width = width;
    this.height = height;
    this.widthRatio = widthRatio;
    reset();
  }

  /// Reset data
  void reset() {
    translateX = width + Random().nextDouble() * 20.0 * width;
    radians = -Random().nextDouble() * 0.07 - 0.05;
    translateY = Random().nextDouble() * 0.5 * height * widthRatio;
  }

  /// Move
  void move() {
    translateX -= 20;
    if (translateX <= -1.0 * width / widthRatio) {
      reset();
    }
  }
}

class _StarParam {
  /// x coordinate
  late double x;

  /// y coordinate
  late double y;

  /// Opacity value, default is 0
  double alpha = 0.0;

  /// Scale
  late double scale;

  /// Whether the animation is reversed.
  bool reverse = false;

  /// Current index value
  int index;

  late double width;

  late double height;

  late double widthRatio;

  _StarParam(this.index);

  void reset() {
    alpha = 0;
    double baseScale = index == 0 ? 0.7 : 0.5;
    scale = (Random().nextDouble() * 0.1 + baseScale) * widthRatio;
    x = Random().nextDouble() * 1 * width / scale;
    y = Random().nextDouble() * max(0.3 * height, 150);
    reverse = false;
  }

  /// Initialize parameters
  void init(width, height, widthRatio) {
    this.width = width;
    this.height = height;
    this.widthRatio = widthRatio;
    alpha = Random().nextDouble();
    double baseScale = index == 0 ? 0.7 : 0.5;
    scale = (Random().nextDouble() * 0.1 + baseScale) * widthRatio;
    x = Random().nextDouble() * 1 * width / scale;
    y = Random().nextDouble() * max(0.3 * height, 150);
    reverse = false;
  }

  /// This method is triggered after each drawing is completed, and the movement begins
  void move() {
    if (reverse == true) {
      alpha -= 0.01;
      if (alpha < 0) {
        reset();
      }
    } else {
      alpha += 0.01;
      if (alpha > 1.2) {
        reverse = true;
      }
    }
  }
}
