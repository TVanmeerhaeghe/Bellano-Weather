import 'package:flutter/material.dart';

class CityProvider with ChangeNotifier {
  String _cityName = '';

  String get cityName => _cityName;

  void setCityName(String name) {
    _cityName = name;
    notifyListeners();
  }

  void clearCityName() {
    _cityName = '';
    notifyListeners();
  }
}
