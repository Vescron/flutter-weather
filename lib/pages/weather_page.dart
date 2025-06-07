import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with AutomaticKeepAliveClientMixin {
  Weather? weather;
  String conditionImage = 'assets/cloudy.json';
  bool _isLoading = false;

  Future<void> showCityDialog() async {
    String enteredCity = "";
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter City Name'),
          content: TextField(
            onChanged: (value) {
              enteredCity = value;
            },
            decoration: const InputDecoration(hintText: "City Name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );

    if (enteredCity.isNotEmpty) {
      // Fetch weather data using the entered city
      final currentWeather = await getWeather(enteredCity);
      setState(() {
        weather = currentWeather;
      });
    }
  }

  Future<void> fetchWeather() async {
    if (_isLoading) return; // Prevent overlapping fetches
    setState(() {
      _isLoading = true;
    });
    String currentCity;
    try {
      currentCity = await getCurrentCity();
    } catch (e) {
      print("Error fetching current city: $e");
      await showCityDialog();
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final currentWeather = await getWeather(currentCity);
    switch (currentWeather.description.toLowerCase()) {
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
        conditionImage = 'assets/rain.json';
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
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Important: call super.build when using keep alive
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_pin,
                        color: Colors.grey.withOpacity(1)),
                    Text(
                      weather?.city ?? 'loading...',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            // .withOpacity(0.5),
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Expanded(child: Lottie.asset(conditionImage)),
                Text(
                  '${weather?.temperature.round().toString() ?? '..'}°C',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        // .withOpacity(0.5),
                  ),
                ),
                Text(
                  weather?.description ?? 'loading...',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .colorScheme
                        .tertiary
                        // .withOpacity(0.5),
                  ),
                )
              ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.background,
        onPressed: fetchWeather,
        child: Icon(Icons.refresh,
            color: Theme.of(context).colorScheme.secondary),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}