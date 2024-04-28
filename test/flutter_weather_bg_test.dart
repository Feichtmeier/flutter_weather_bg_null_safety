import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox.square(
            dimension: 500,
            child: WeatherBg(
              weatherType: WeatherType.sunny,
              width: 500,
              height: 500,
            ),
          ),
        ),
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.byType(WeatherBg), findsOneWidget);
  });
}
