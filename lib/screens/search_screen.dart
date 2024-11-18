import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/city_provider.dart';
import '../widgets/weather_card.dart';

class SearchScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final cityProvider = Provider.of<CityProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Rechercher une ville',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  cityProvider.setCityName(_controller.text.trim());
                  weatherProvider
                      .loadSearchedCityWeather(cityProvider.cityName);
                },
              ),
            ),
            onSubmitted: (value) {
              cityProvider.setCityName(value.trim());
              weatherProvider.loadSearchedCityWeather(cityProvider.cityName);
            },
          ),
          const SizedBox(height: 16),
          if (cityProvider.cityName.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Résultat de la recherche pour : ${cityProvider.cityName}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                weatherProvider.isLoadingSearch
                    ? const Center(
                        child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ))
                    : weatherProvider.searchedCityWeather == null
                        ? Center(
                            child: Text(
                                'Aucune donnée pour "${cityProvider.cityName}"'))
                        : WeatherCard(
                            weather: weatherProvider.searchedCityWeather!),
              ],
            ),
        ],
      ),
    );
  }
}
