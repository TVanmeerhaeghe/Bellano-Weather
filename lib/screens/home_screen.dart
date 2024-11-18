import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/city_provider.dart';
import '../widgets/weather_card.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false)
          .loadUserLocationWeather();
    });
  }

  Future<void> _refreshWeatherData() async {
    await Provider.of<WeatherProvider>(context, listen: false)
        .refreshWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    Provider.of<CityProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Météo')),
      body: RefreshIndicator(
        onRefresh: _refreshWeatherData,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              if (_selectedIndex == 0) ...[
                const Text(
                  "Mon emplacement",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                weatherProvider.isLoadingUserLocation
                    ? const Center(child: CircularProgressIndicator())
                    : weatherProvider.userLocationWeather == null
                        ? const Center(
                            child: Text('Aucune donnée pour votre emplacement'))
                        : WeatherCard(
                            weather: weatherProvider.userLocationWeather!,
                            locationLabel:
                                weatherProvider.userLocationWeather!.cityName,
                          ),
                const SizedBox(height: 16),
                if (weatherProvider.favoriteWeathers.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Favoris",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...weatherProvider.favoriteWeathers
                          .map((weather) => WeatherCard(weather: weather)),
                    ],
                  ),
              ],
              if (_selectedIndex == 1) SearchScreen(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightBlueAccent[100],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[700],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Recherche',
          ),
        ],
      ),
    );
  }
}
