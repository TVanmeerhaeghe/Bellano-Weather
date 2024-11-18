import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/weather.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';

class WeatherProvider with ChangeNotifier {
  Weather? _userLocationWeather;
  Weather? _searchedCityWeather;
  List<Weather> _favoriteWeathers = [];
  bool _isLoadingUserLocation = false;
  bool _isLoadingSearch = false;

  Weather? get userLocationWeather => _userLocationWeather;
  Weather? get searchedCityWeather => _searchedCityWeather;
  List<Weather> get favoriteWeathers => _favoriteWeathers;
  bool get isLoadingUserLocation => _isLoadingUserLocation;
  bool get isLoadingSearch => _isLoadingSearch;

  final ApiService _apiService = ApiService();
  final LocationService _locationService = LocationService();

  WeatherProvider() {
    loadFavorites();
  }

  // Méthode pour rafraîchir les données météo de l'utilisateur et des favoris
  Future<void> refreshWeatherData() async {
    await loadUserLocationWeather();
    await updateFavoriteWeathers();
  }

  Future<void> updateFavoriteWeathers() async {
    final favoritesBox = Hive.box<Weather>('favorites');
    final updatedWeathers =
        await Future.wait(_favoriteWeathers.map((weather) async {
      final updatedWeather =
          await _apiService.fetchWeatherByCityName(weather.cityName);
      await favoritesBox.put(updatedWeather.cityName, updatedWeather);
      return updatedWeather;
    }).toList());

    _favoriteWeathers = updatedWeathers;
    notifyListeners();
  }

  Future<void> loadUserLocationWeather() async {
    _isLoadingUserLocation = true;
    notifyListeners();

    try {
      final location = await _locationService.getCurrentLocation();
      _userLocationWeather =
          await _apiService.fetchWeather(location.latitude, location.longitude);
    } catch (e) {
      _userLocationWeather = null;
    } finally {
      _isLoadingUserLocation = false;
      notifyListeners();
    }
  }

  Future<void> loadSearchedCityWeather(String cityName) async {
    _isLoadingSearch = true;
    notifyListeners();

    try {
      final coords = await _apiService.getCoordinatesFromCity(cityName);
      _searchedCityWeather =
          await _apiService.fetchWeather(coords['lat']!, coords['lon']!);
    } catch (e) {
      _searchedCityWeather = null;
    } finally {
      _isLoadingSearch = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Weather weather) async {
    final favoritesBox = Hive.box<Weather>('favorites');
    if (_favoriteWeathers.any((fav) => fav.cityName == weather.cityName)) {
      _favoriteWeathers.removeWhere((fav) => fav.cityName == weather.cityName);
      await favoritesBox.delete(weather.cityName);
    } else {
      _favoriteWeathers.add(weather);
      await favoritesBox.put(weather.cityName, weather);
    }
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    final favoritesBox = Hive.box<Weather>('favorites');
    _favoriteWeathers = favoritesBox.values.toList().cast<Weather>();
    notifyListeners();
  }

  void clearSearch() {
    _searchedCityWeather = null;
    notifyListeners();
  }
}
