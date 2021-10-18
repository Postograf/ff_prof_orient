import 'package:ff_to_play_dota_2/api_workers/weather_forecaster.dart';
import 'package:ff_to_play_dota_2/models/cities_model.dart';
import 'package:ff_to_play_dota_2/models/settings_model.dart';
import 'package:ff_to_play_dota_2/models/weather_icons.dart';
import 'package:ff_to_play_dota_2/neumorphic_extensions/neumorphic_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:developer' as dev;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: _WuetherDrawer(),
    body: SlidingUpPanel(
      color: Theme.of(context).backgroundColor,
      minHeight: 230,
      maxHeight: 350,
      panel: const HourlyForecast(expanded: true,),
      collapsed: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(30))
        ),
        child: const HourlyForecast(expanded: false),
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Theme.of(context).brightness == Brightness.light
                ? const AssetImage("assets/Backrounds/light.png")
                : const AssetImage("assets/Backrounds/dark.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(children: [
              const Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Builder(builder: (context) => NeumorphicIconButton
                      (
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: const Icon(
                          Icons.menu,
                          size: 35,
                          color: Colors.white,
                        )
                      ),
                    ),
                    Consumer<CitiesModel>(
                      builder: (context, cities, child) {
                        return Text(
                            cities.currentCity,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Manrope'
                            )
                        );
                      },
                    ),
                    NeumorphicIconButton(
                        onPressed: () {
                          setState(() {
                            Navigator.pushNamed(context, '/search');
                          });
                        },
                        icon: const Icon(
                          Icons.add_circle_outline,
                          size: 35,
                          color: Colors.white,
                        )
                    ),
                  ]
              ),
              const SizedBox(height: 20),
              _CurrentTemperature(),
            ]),
          )
      ),
    ),
  );
}

class _WuetherDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Wuether',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.settings_outlined,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: const Text('Настройки'),
                onTap: () => Navigator.pushNamed(context, '/settings'),
              ),
              ListTile(
                leading: Icon(
                  Icons.favorite_outline,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: const Text('Избранное'),
                onTap: () => Navigator.pushNamed(context, '/favourite'),
              ),
              ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: const Text('О приложении'),
                  onTap: () => Navigator.pushNamed(context, '/info'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrentTemperature extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var cities = context.watch<CitiesModel>();
    var settings = context.watch<SettingsModel>();

    return FutureBuilder<WeatherForecast>(
      future: cities.fetchWeatherForecast(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          dev.log('Error: ${snapshot.error}');
          return const Text(
            'Не удалось получить данные',
            style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Manrope'),
          );
        }
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(color: Colors.white);
        }
        var date = snapshot.data!.current.date;
        return Column(
          children: [
            Text(
              settings.formatTemp(snapshot.data!.current.temp),
              style: const TextStyle(fontSize: 80, color: Colors.white, fontFamily: 'Manrope'),
            ),
            Text(
              '${date.day} ${_shortMonths[date.month]} ${date.year}',
              style: const TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'Manrope'),
            ),
          ],
        );
      },
    );
  }
}

class HourlyForecast extends StatelessWidget {
  final bool _expanded;

  const HourlyForecast({required bool expanded, Key? key})
      : _expanded = expanded,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var cities = context.watch<CitiesModel>();

    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 5)),
        Container(
          height: 7,
          width: 70,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.all(Radius.circular(30))
          ),
        ),
        const SizedBox(height: 20),
        FutureBuilder<WeatherForecast>(
          future: cities.fetchWeatherForecast(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Не удалось получить данные');
            }
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            if (_expanded) {
              return _buildExpanded(context, snapshot.data!);
            } else {
              return _buildCollapsed(context, snapshot.data!);
            }
          },
        ),
      ],
    );
  }
}

Widget _buildCollapsed(BuildContext context, WeatherForecast forecast) {
  var settings = context.watch<SettingsModel>();

  return Column(
    children: [
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _WeatherCard(forecast.hourly[12], settings),
              _WeatherCard(forecast.hourly[18], settings),
              _WeatherCard(forecast.hourly[0], settings),
              _WeatherCard(forecast.hourly[6], settings),
            ],
          ),
          const SizedBox(height: 10),
          TextButton(
            style: ButtonStyle(shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                )
            )),
            child: const Text('Прогноз на неделю'),
            onPressed: () => Navigator.pushNamed(context, '/week'),
          ),
        ],
      ),
    ],
  );
}

Widget _buildExpanded(BuildContext context, WeatherForecast forecast) {
  var settings = context.watch<SettingsModel>();

  var date = forecast.current.date;
  return Column(
    children: [
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _WeatherCard(forecast.hourly[12], settings),
          _WeatherCard(forecast.hourly[18], settings),
          _WeatherCard(forecast.hourly[0], settings),
          _WeatherCard(forecast.hourly[6], settings),
        ],
      ),
      const SizedBox(height: 10),
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        padding: const EdgeInsets.all(8),
        children: [
          _WeatherParamCard(
            const AssetImage('assets/WeatherIcons/temperature.png'),
            settings.formatTemp(forecast.current.temp),
          ),
          _WeatherParamCard(
            const AssetImage('assets/WeatherIcons/humidity.png'),
            '${forecast.current.humidity}%',
          ),
          _WeatherParamCard(
            const AssetImage('assets/WeatherIcons/wind.png'),
            settings.formatSpeed(forecast.current.windSpeed),
          ),
          _WeatherParamCard(
            const AssetImage('assets/WeatherIcons/pressure.png'),
            settings.formatPressure(forecast.current.pressure),
          ),
        ],
      ),
    ],
  );
}

class _WeatherParamCard extends StatelessWidget {
  final ImageProvider image;
  final String text;

  const _WeatherParamCard(this.image, this.text);

  @override
  Widget build(BuildContext context) {
    var iconTint = Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white;

    return Card(
      elevation: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: image, color: iconTint, width: 20, height: 20),
          const SizedBox(width: 5),
          Text(text),
        ],
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  final Weather _weather;
  final SettingsModel _settings;

  const _WeatherCard(this._weather, this._settings);

  @override
  Widget build(BuildContext context) {
    var imgPath = weatherIcons[_weather.conditionCode];
    Widget img;
    if (imgPath != null) {
      img = Image(
        image: AssetImage(imgPath),
        width: 50,
        height: 50,
      );
    } else {
      img = SizedBox(
        width: 50,
        height: 50,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: Center(
            child: Text(_weather.conditionCode.toString()),
          ),
        ),
      );
    }

    return Neumorphic(
      style: const NeumorphicStyle(
        lightSource: LightSource.top,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          children: [
            Text(DateFormat('HH:mm').format(_weather.date)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: img,
            ),
            Text(_settings.formatTemp(_weather.temp)),
          ],
        ),
      ),
    );
  }
}

const _months = {
  DateTime.january: 'января',
  DateTime.february: 'февраля',
  DateTime.march: 'марта',
  DateTime.april: 'апреля',
  DateTime.may: 'мая',
  DateTime.june: 'июня',
  DateTime.july: 'июля',
  DateTime.august: 'августа',
  DateTime.september: 'сентября',
  DateTime.october: 'октября',
  DateTime.november: 'ноября',
  DateTime.december: 'декабря',
};

const _shortMonths = {
  DateTime.january: 'янв.',
  DateTime.february: 'февр.',
  DateTime.march: 'марта',
  DateTime.april: 'апр.',
  DateTime.may: 'мая',
  DateTime.june: 'июня',
  DateTime.july: 'июля',
  DateTime.august: 'авг.',
  DateTime.september: 'сент.',
  DateTime.october: 'окт.',
  DateTime.november: 'ноября',
  DateTime.december: 'дек.',
};