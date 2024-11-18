import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/weather.dart';
import '../providers/weather_provider.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  final Weather weather;

  const DetailScreen({super.key, required this.weather});

  String formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final isFavorite = weatherProvider.favoriteWeathers
        .any((fav) => fav.cityName == weather.cityName);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails de la météo"),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              weatherProvider.toggleFavorite(weather);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    weather.cityName,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[800]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${weather.temperature} °C",
                    style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                        color: Colors.blue),
                  ),
                  Text(
                    weather.description,
                    style:
                        const TextStyle(fontSize: 20, color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
            Divider(height: 30, thickness: 1, color: Colors.blueGrey[200]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherDetail(
                    icon: Icons.water_drop,
                    label: "Humidité",
                    value: "${weather.humidity} %"),
                _buildWeatherDetail(
                    icon: Icons.wind_power,
                    label: "Vent",
                    value: "${weather.windSpeed} m/s"),
                _buildWeatherDetail(
                    icon: Icons.compress,
                    label: "Pression",
                    value: "${weather.pressure} hPa"),
              ],
            ),
            Divider(height: 30, thickness: 1, color: Colors.blueGrey[200]),
            const SizedBox(height: 16),
            Text(
              "Phases de la journée",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800]),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDayPhase(
                    icon: Icons.wb_sunny_outlined,
                    label: "Lever du soleil",
                    time: formatTimestamp(weather.sunrise),
                    iconColor: Colors.orange),
                _buildDayPhase(
                    icon: Icons.nights_stay_outlined,
                    label: "Coucher du soleil",
                    time: formatTimestamp(weather.sunset),
                    iconColor: Colors.indigo),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(
      {required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.blueGrey[600])),
        Text(value, style: const TextStyle(fontSize: 18)),
      ],
    );
  }

  Widget _buildDayPhase(
      {required IconData icon,
      required String label,
      required String time,
      required Color iconColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.blueGrey)),
          ],
        ),
        Text(
          time,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
