import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:weather/pages/weather_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic){
      return MaterialApp(
        theme: ThemeData(
          colorScheme: lightDynamic,
          useMaterial3: true
        ),
        darkTheme: ThemeData(
          colorScheme: darkDynamic,
          useMaterial3: true
        ),
        themeMode: ThemeMode.system,
        home: WeatherPage(),
      );
  });
  }
}
