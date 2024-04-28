import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'weather_bg.dart';
import '../utils/image_utils.dart';
import '../utils/weather_type.dart';

/// Thunder animation layer
class WeatherThunderBg extends StatefulWidget {
  final WeatherType weatherType;

  const WeatherThunderBg({super.key, required this.weatherType});

  @override
  State<WeatherThunderBg> createState() => _WeatherCloudBgState();
}

class _WeatherCloudBgState extends State<WeatherThunderBg>
    with SingleTickerProviderStateMixin {
  final List<ui.Image> _images = [];
  late AnimationController _controller;
  final List<ThunderParams> _thunderParams = [];
  WeatherDataState? _state;

  /// Asynchronously fetch thunder images resources
  Future<void> fetchImages() async {
    var image1 = await ImageUtils.getImage('images/lightning0.webp');
    var image2 = await ImageUtils.getImage('images/lightning1.webp');
    var image3 = await ImageUtils.getImage('images/lightning2.webp');
    var image4 = await ImageUtils.getImage('images/lightning3.webp');
    var image5 = await ImageUtils.getImage('images/lightning4.webp');
    _images.add(image1);
    _images.add(image2);
    _images.add(image3);
    _images.add(image4);
    _images.add(image5);
    _state = WeatherDataState.init;
    setState(() {});
  }

  @override
  void initState() {
    fetchImages();
    initAnim();
    super.initState();
  }

  // This is used to initialize the animation, looping the three lightning bolts as a group for display
  void initAnim() {
    _controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        Future.delayed(const Duration(milliseconds: 50)).then((value) {
          initThunderParams();
          _controller.forward();
        });
      }
    });

    // Construct animation data for the first lightning
    var animation = TweenSequence([
      TweenSequenceItem(
        tween:
            Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween:
            Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 3,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.3,
          curve: Curves.ease,
        ),
      ),
    );

    // Construct animation data for the second lightning
    var animation1 = TweenSequence([
      TweenSequenceItem(
        tween:
            Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween:
            Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 3,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.2,
          0.5,
          curve: Curves.ease,
        ),
      ),
    );

    // Construct animation data for the third lightning
    var animation2 = TweenSequence([
      TweenSequenceItem(
        tween:
            Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween:
            Tween(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 3,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.6,
          0.9,
          curve: Curves.ease,
        ),
      ),
    );

    animation.addListener(() {
      if (_thunderParams.isNotEmpty) {
        _thunderParams[0].alpha = animation.value;
      }
      setState(() {});
    });

    animation1.addListener(() {
      if (_thunderParams.isNotEmpty) {
        _thunderParams[1].alpha = animation1.value;
      }
      setState(() {});
    });

    animation2.addListener(() {
      if (_thunderParams.isNotEmpty) {
        _thunderParams[2].alpha = animation2.value;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Build thunder widget
  Widget _buildWidget() {
    // Here we need to check the weather type to prevent unnecessary drawing when it's not needed, which could impact performance
    if (_thunderParams.isNotEmpty &&
        widget.weatherType == WeatherType.thunder) {
      return CustomPaint(
        painter: ThunderPainter(_thunderParams),
      );
    } else {
      return Container();
    }
  }

  /// Initialize thunderstorm parameters
  void initThunderParams() {
    _state = WeatherDataState.loading;
    _thunderParams.clear();
    var size = SizeInherited.of(context)?.size;
    var width = size?.width ?? double.infinity;
    var height = size?.height ?? double.infinity;
    var widthRatio = width / 392.0;
    // Configure three lightning parameters
    for (var i = 0; i < 3; i++) {
      var param = ThunderParams(
        _images[Random().nextInt(5)],
        width,
        height,
        widthRatio,
      );
      param.reset();
      _thunderParams.add(param);
    }
    _controller.forward();
    _state = WeatherDataState.finish;
  }

  @override
  Widget build(BuildContext context) {
    if (_state == WeatherDataState.init) {
      initThunderParams();
    } else if (_state == WeatherDataState.finish) {
      return _buildWidget();
    }
    return Container();
  }
}

class ThunderPainter extends CustomPainter {
  final _paint = Paint();
  final List<ThunderParams> thunderParams;

  ThunderPainter(this.thunderParams);

  @override
  void paint(Canvas canvas, Size size) {
    if (thunderParams.isNotEmpty) {
      for (var param in thunderParams) {
        drawThunder(param, canvas, size);
      }
    }
  }

  /// This is responsible for drawing thunder
  void drawThunder(ThunderParams params, Canvas canvas, Size size) {
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
      params.alpha,
      0,
    ]);
    _paint.colorFilter = identity;
    canvas.scale(params.widthRatio * 1.2);
    canvas.drawImage(params.image, Offset(params.x, params.y), _paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ThunderParams {
  /// Configure thunder image resources
  late ui.Image image;
  // x-coordinate of the image display
  late double x;
  // y-coordinate of the image display
  late double y;
  // Alpha property of the lightning
  late double alpha;
  // Width of the thunder image
  int get imgWidth => image.width;
  // Height of the thunder image
  int get imgHeight => image.height;
  final double width, height, widthRatio;

  ThunderParams(this.image, this.width, this.height, this.widthRatio);

  // Reset the position information of the image
  void reset() {
    x = Random().nextDouble() * 0.5 * widthRatio - 1 / 3 * imgWidth;
    y = Random().nextDouble() * -0.05 * height;
    alpha = 0;
  }
}
