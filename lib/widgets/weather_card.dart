import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../screens/detail_screen.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  final String? locationLabel;

  WeatherCard({required this.weather, this.locationLabel});

  String getIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(weather: weather),
            ),
          );
        },
        child: Card(
          color: Colors.lightBlueAccent[100],
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locationLabel ?? weather.cityName,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('${weather.temperature} °C',
                        style: const TextStyle(fontSize: 18)),
                    Text(weather.description,
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
                Image.network(
                  getIconUrl(weather.icon),
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
