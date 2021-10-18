import 'dart:collection';

import 'package:ff_to_play_dota_2/api_workers/weather_forecaster.dart';
import 'package:ff_to_play_dota_2/prefs/Prefs.dart';
import 'package:flutter/foundation.dart';
import 'package:async/async.dart';

class CitiesModel extends ChangeNotifier {
  final _weatherCache = AsyncCache<WeatherForecast>(const Duration(minutes: 5));

  String _currentCity;
  final Set<String> _favoriteCities;

  CitiesModel()
      : _currentCity = Prefs.instance.getString('current_city') ?? 'Санкт-Петербург',
        _favoriteCities = (Prefs.instance.getStringList('favorite_cities') ?? []).toSet();

  String get currentCity => _currentCity;
  set currentCity(String city) {
    if (_currentCity != city) {
      _currentCity = city;
      _weatherCache.invalidate();
      Prefs.instance.setString('current_city', city);

      notifyListeners();
    }
  }

  UnmodifiableListView get favoriteCities => UnmodifiableListView(_favoriteCities);

  Future<WeatherForecast> fetchWeatherForecast() => _weatherCache.fetch(() {
    return fetchWeatherForecastByCity(_currentCity);
  });

  void addFavoriteCity(String city) {
    _favoriteCities.add(city);
    Prefs.instance.setStringList('favorite_cities', _favoriteCities.toList(growable: false));

    notifyListeners();
  }

  void removeFavoriteCity(String city) {
    _favoriteCities.remove(city);
    Prefs.instance.setStringList('favorite_cities', _favoriteCities.toList(growable: false));

    notifyListeners();
  }
}