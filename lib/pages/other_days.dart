import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather_service.dart';

class OtherDaysPage extends StatefulWidget {
  const OtherDaysPage({super.key});

  @override
  State<OtherDaysPage> createState() => _OtherDaysPageState();
}

class _OtherDaysPageState extends State<OtherDaysPage> with AutomaticKeepAliveClientMixin {
  late Future<Object> forecastFuture;

  Future<Object> getForecast() async {
    // Fetch other days weather data from an API
    final response = await http.get(Uri.parse('https://www.wttr.in/${await getCurrentCity()}?format=j1'));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      return jsonDecode(response.body); // You can process the response as needed
    } else {
      // If the server returns an error response, throw an exception.
      throw Exception('Failed to load forecast data');
    }
  }

  String getConditionAsset(String condition) {
  final cond = condition.toLowerCase();
  if (cond.contains('clear') || cond.contains('sunny')) {
    return 'assets/sunny.json';
  } else if (cond.contains('cloud') || cond.contains('mist') || cond.contains('haze') ||
      cond.contains('smoke') || cond.contains('dust') || cond.contains('fog')) {
    return 'assets/cloudy.json';
  } else if (cond.contains('drizzle') || cond.contains('rain')) {
    return 'assets/rain.json';
  } else if (cond.contains('thunder')) {
    return 'assets/thunderstorm.json';
  } else {
    return 'assets/cloudy.json';
  }
}

  @override
  void initState() {
    super.initState();
    forecastFuture = getForecast();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Important: call super.build when using keep alive
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Text(
                'Overview of Next 2 Days',
                style: GoogleFonts.bebasNeue(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              FutureBuilder<Object>(
                future: forecastFuture, // Use the stored future here
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: \\${snapshot.error}');
                  } else {
                    // Assuming the response is a Map<String, dynamic>
                    final data = snapshot.data as Map<String, dynamic>;
                    final List<dynamic> weatherList = data['weather'];
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: 2, // Only next 2 days (index 1 and 2)
                      itemBuilder: (context, i) {
                        final index = i + 1; // Start from index 1
                        final day = weatherList[index];
                        final date = day['date'];
                        final avgTemp = day['avgtempC'];
                        final maxTemp = day['maxtempC'];
                        final minTemp = day['mintempC'];
                        final desc = day['hourly'][0]['weatherDesc'][0]['value'];
                        final assetPath = getConditionAsset(desc);

                        // Convert date string to weekday name
                        String dayName = date;
                        try {
                          final parsedDate = DateTime.parse(date);
                          dayName = DateFormat('EEEE').format(parsedDate); // e.g., Monday
                        } catch (e) {
                          // If parsing fails, fallback to original date string
                        }

                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Lottie.asset(assetPath,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  dayName,
                                  style: GoogleFonts.bebasNeue(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                Text(
                                  '$avgTemp°C',
                                  style: GoogleFonts.bebasNeue(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                Text(
                                  'Max: $maxTemp°C   Min: $minTemp°C',
                                  style: GoogleFonts.bebasNeue(
                                    fontSize: 18,
                                    color: Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                                Text(
                                  desc,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.bebasNeue(
                                    fontSize: 22,
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}