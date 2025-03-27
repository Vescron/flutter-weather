import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  Weather? weather;
  String conditionImage = 'assets/cloudy.json';

  fetchWeather() async {
    String currentCity = await getCurrentCity();
    final currentWeather = await getWeather(currentCity);
    switch(currentWeather.description.toLowerCase()) {
      case 'clear':
        conditionImage = 'assets/sunny.json';
        break;
      case 'clouds':
      case 'mist':
      case 'haze':
      case 'smoke':
      case 'dust':
      case 'fog':
        conditionImage = 'assets/cloudy.json';
        break;
      case 'drizzle':
      case 'rain':
        conditionImage = 'assets/rainy.json';
        break;
      case 'thunderstorm':
        conditionImage = 'assets/thunderstorm.json';
        break;
      default:
        conditionImage = 'assets/cloudy.json';
        break;
    }
    setState(() {
      weather = currentWeather;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.location_pin,color: Colors.grey.withOpacity(1)),
                  Text(weather?.city ?? 'loading...',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              Expanded(child: Lottie.asset(conditionImage)),
              Text('${weather?.temperature.round().toString() ?? '..'}°C',
              style: GoogleFonts.bebasNeue(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.withOpacity(0.5),
                  ),
              ),
              Text(weather?.description ?? 'loading...',
              style: GoogleFonts.bebasNeue(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.withOpacity(0.5),
                  ),
              )
            ]
          ),
        ),
      ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.background, 
      onPressed: fetchWeather,
      child: Icon(Icons.refresh, color: Colors.white),
    ),
    floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}