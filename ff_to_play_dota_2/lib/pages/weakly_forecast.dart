
import 'package:ff_to_play_dota_2/api_workers/weather_forecaster.dart';
import 'package:ff_to_play_dota_2/models/cities_model.dart';
import 'package:ff_to_play_dota_2/models/settings_model.dart';
import 'package:ff_to_play_dota_2/models/weather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_stack_card/flutter_stack_card.dart';
import 'package:provider/provider.dart';

class WeeklyForecastPage extends StatelessWidget {
  const WeeklyForecastPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cities = context.watch<CitiesModel>();

    return Scaffold(
      appBar: NeumorphicAppBar(
        title: const Text('Прогноз на неделю'),
      ),
      body: FutureBuilder<WeatherForecast>(
          future: cities.fetchWeatherForecast(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Не удалось получить данные'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            //var weatherCards = [for (var i = 0; i < 7; i++) _WeatherDayCard(snapshot.data!.daily[i])];
            return StackCard.builder(
                stackOffset: const Offset(20, 0),
                itemCount: 7,
                itemBuilder: (context, index) {
                  return _WeatherDayCard(snapshot.data!.daily[index]);
                },
            );
            // return ListView(
            //   padding: const EdgeInsets.all(15),
            //   children: weatherCards,
            // );
          }
      ),
    );
  }
}

class _WeatherDayCard extends StatelessWidget {
  final Weather _weather;

  const _WeatherDayCard(this._weather);

  @override
  Widget build(BuildContext context) {
    const lightGradient = [
      Color.fromARGB(255, 205, 218, 245),
      Color.fromARGB(255, 160, 190, 255),
    ];
    const darkGradient = [
      Color.fromARGB(255, 35, 59, 112),
      Color.fromARGB(255, 16, 32, 66),
    ];

    var imgPath = weatherIcons[_weather.conditionCode];
    Widget img;
    if (imgPath != null) {
      img = Image(
        image: AssetImage(imgPath),
        width: 100,
        height: 100,
      );
    } else {
      img = SizedBox(
        width: 100,
        height: 100,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Center(
            child: Text(
              _weather.conditionCode.toString(),
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      );
    }

    var units = context.watch<SettingsModel>();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Theme.of(context).brightness == Brightness.light ? lightGradient : darkGradient,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _daysOfWeek[_weather.date.weekday]!,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: img,
              ),
              _WeatherParam(
                image: const AssetImage('assets/WeatherIcons/temperature.png'),
                text: units.formatTemp(_weather.temp),
              ),
              _WeatherParam(
                image: const AssetImage('assets/WeatherIcons/wind.png'),
                text: units.formatSpeed(_weather.windSpeed),
              ),
              _WeatherParam(
                image: const AssetImage('assets/WeatherIcons/humidity.png'),
                text: '${_weather.humidity}%',
              ),
              _WeatherParam(
                image: const AssetImage('assets/WeatherIcons/pressure.png'),
                text: units.formatPressure(_weather.pressure),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherParam extends StatelessWidget {
  final ImageProvider image;
  final String text;

  const _WeatherParam({required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    var iconTint = Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white;

    return ListTile(
      dense: true,
      minLeadingWidth: 0,
      leading: Image(image: image, width: 20, height: 20, color: iconTint),
      title: Text(
        text,
        style: const TextStyle(fontSize: 17),
      ),
    );
  }
}

const _daysOfWeek = {
  DateTime.monday: 'Понедельник',
  DateTime.tuesday: 'Вторник',
  DateTime.wednesday: 'Среда',
  DateTime.thursday: 'Четверг',
  DateTime.friday: 'Пятница',
  DateTime.saturday: 'Суббота',
  DateTime.sunday: 'Воскресенье',
};