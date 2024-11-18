import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class ApiService {
  final String apiKey = 'd04357fee1c7095ac2d93fce97717adf';

  Future<Weather> fetchWeather(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric&lang=fr');
    print(
        "Appel de l'API OpenWeather pour la météo actuelle avec l'URL : $url");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      print("Erreur lors de l'appel API : ${response.body}");
      throw Exception('Erreur lors du chargement des données météo');
    }
  }

  Future<Map<String, double>> getCoordinatesFromCity(String cityName) async {
    final url = Uri.parse(
        'http://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=5&appid=$apiKey');
    print("Appel de l'API de géocodage avec l'URL : $url");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      if (data.isNotEmpty) {
        final cityResult = data.firstWhere(
          (location) => (location['name'].toString().toLowerCase() ==
              cityName.toLowerCase()),
          orElse: () => data[0],
        );

        final latitude = cityResult['lat'] as double;
        final longitude = cityResult['lon'] as double;
        print(
            "Ville trouvée : ${cityResult['name']} (Latitude: $latitude, Longitude: $longitude)");

        return {'lat': latitude, 'lon': longitude};
      } else {
        throw Exception('Aucune ville trouvée pour "$cityName".');
      }
    } else {
      print("Erreur lors de l'appel API : ${response.body}");
      throw Exception('Erreur lors de la récupération des coordonnées.');
    }
  }

  Future<Weather> fetchWeatherByCityName(String cityName) async {
    final coords = await getCoordinatesFromCity(cityName);
    return fetchWeather(coords['lat']!, coords['lon']!);
  }
}
