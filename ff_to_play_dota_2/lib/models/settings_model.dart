import 'package:ff_to_play_dota_2/prefs/Prefs.dart';
import 'package:flutter/cupertino.dart';

enum TemperatureUnit { c, f }
enum WindSpeedUnit { ms, kmH }
enum PressureUnit { mmHg, hPa }

class SettingsModel extends ChangeNotifier {
  TemperatureUnit _temperature;
  WindSpeedUnit _windSpeed;
  PressureUnit _pressure;

  TemperatureUnit get temperature => _temperature;
  WindSpeedUnit get windSpeed => _windSpeed;
  PressureUnit get pressure => _pressure;

  SettingsModel()
      : _temperature = Prefs.instance.getString('temp_unit') == 'F' ? TemperatureUnit.f : TemperatureUnit.c,
        _windSpeed = Prefs.instance.getString('speed_unit') == 'km_h' ? WindSpeedUnit.kmH : WindSpeedUnit.ms,
        _pressure = Prefs.instance.getString('pressure_unit') == 'hpa' ? PressureUnit.hPa : PressureUnit.mmHg;

  void updateSettings({
    TemperatureUnit? temperatureUnit,
    WindSpeedUnit? windSpeedUnit,
    PressureUnit? pressureUnit
  }){
    _temperature = temperatureUnit ?? _temperature;
    _windSpeed = windSpeedUnit ?? _windSpeed;
    _pressure = pressureUnit ?? _pressure;
    save();
    notifyListeners();
  }

  void save() {
    Prefs.instance.setString('temp_unit', _temperature == TemperatureUnit.c ? 'C' : 'F');
    Prefs.instance.setString('speed_unit', _windSpeed == WindSpeedUnit.kmH ? 'km_h' : 'm_s');
    Prefs.instance.setString('pressure_unit', _pressure == PressureUnit.hPa ? 'hpa' : 'mm_hg');
  }

  String formatTemp(double temperatureC) {
    if (_temperature == TemperatureUnit.c) {
      return '${temperatureC.round()}˚C';
    } else {
      return '${(temperatureC * 9 / 5 + 32).round()}˚F';
    }
  }

  String formatSpeed(double speedMs) {
    if (_windSpeed == WindSpeedUnit.ms) {
      return '$speedMs м/с';
    } else {
      return '${(speedMs * 3.6).round()} м/с';
    }
  }

  String formatPressure(int pressureHPa) {
    if (_pressure == PressureUnit.hPa) {
      return '$pressureHPa гПа';
    } else {
      return '${(pressureHPa / 1.333).round()} мм.рт.ст.';
    }
  }
}