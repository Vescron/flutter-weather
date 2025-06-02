import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Weather {
  final String city;
  final double temperature;
  final String description;

  Weather({
    required this.city,
    required this.temperature,
    required this.description,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      temperature: (json['main']['temp'] - 273.25),
      description: json['weather'][0]['main'],
    );
  }
}

Future<Weather> getWeather(String city) async {
    // Fetch weather data from an API
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=0fd1287b44b57da2e3e4118d94f046e9'));
    
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      // If the server returns an error response, throw an exception.
      throw Exception('Failed to load weather data');
    }
  }

Future<String> getCurrentCity() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  print("Current position: ${position.latitude}, ${position.longitude}");

  List<Placemark> placemarks = [];
  placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  String? city = placemarks[0].locality;
  return city ?? "";
}

