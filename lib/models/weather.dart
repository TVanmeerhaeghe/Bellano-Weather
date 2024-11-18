import 'package:hive/hive.dart';

part 'weather.g.dart';

@HiveType(typeId: 0)
class Weather extends HiveObject {
  @HiveField(0)
  final String cityName;

  @HiveField(1)
  final double temperature;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double windSpeed;

  @HiveField(4)
  final int humidity;

  @HiveField(5)
  final int pressure;

  @HiveField(6)
  final String icon;

  @HiveField(7)
  final int sunrise;

  @HiveField(8)
  final int sunset;
  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.windSpeed,
    required this.humidity,
    required this.pressure,
    required this.icon,
    required this.sunrise,
    required this.sunset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      windSpeed: json['wind']['speed'].toDouble(),
      humidity: json['main']['humidity'],
      pressure: json['main']['pressure'],
      icon: json['weather'][0]['icon'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
    );
  }
}
