import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/services.dart';

/// Image-related utility class
class ImageUtils {
  /// Convert the ui.Image object needed for drawing using this method
  static Future<ui.Image> getImage(String asset) async {
    ByteData data =
        await rootBundle.load('packages/flutter_weather_bg_null_safety/$asset');
    Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
}
