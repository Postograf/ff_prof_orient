import 'package:ff_to_play_dota_2/models/cities_model.dart';
import 'package:ff_to_play_dota_2/models/settings_model.dart';
import 'package:ff_to_play_dota_2/pages/favorites_page.dart';
import 'package:ff_to_play_dota_2/pages/info_page.dart';
import 'package:ff_to_play_dota_2/pages/search_page.dart';
import 'package:ff_to_play_dota_2/pages/settings_page.dart';
import 'package:ff_to_play_dota_2/pages/weakly_forecast.dart';
import 'package:ff_to_play_dota_2/prefs/Prefs.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:ff_to_play_dota_2/pages/home_page.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await Prefs.init();

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<CitiesModel>(create: (context) => CitiesModel()),
        ChangeNotifierProvider<SettingsModel>(create: (context) => SettingsModel()),
      ],
      child: const WuetherApp(),
  ));
}

class WuetherApp extends StatelessWidget {
  const WuetherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const lightPrimary = Color(0xffe2ebff);
    const darkPrimary = Color(0xff0c1620);

    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      theme: const NeumorphicThemeData(
        baseColor: lightPrimary,
        variantColor: Color(0xffe1e9ff),
        accentColor: Color(0xff4b5f88),
        appBarTheme: NeumorphicAppBarThemeData(
          color: lightPrimary,
        ),
        textTheme: TextTheme(
          subtitle1: TextStyle(color: Colors.black),
          subtitle2: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      darkTheme: const NeumorphicThemeData(
        baseColor: darkPrimary,
        variantColor: Color(0xff0d172b),
        accentColor: Colors.white,
        shadowLightColor: Color(0xFF828282),
        defaultTextColor: Colors.white,
        textTheme: TextTheme(
          subtitle1: TextStyle(color: Colors.white),
          subtitle2: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      materialTheme: ThemeData(
        scaffoldBackgroundColor: lightPrimary,
        backgroundColor: lightPrimary,
        cardColor: lightPrimary,
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: lightPrimary,
        ),
      ),
      materialDarkTheme: ThemeData(
        scaffoldBackgroundColor: darkPrimary,
        primaryColor: Colors.white,
        backgroundColor: darkPrimary,
        cardColor: darkPrimary,
        brightness: Brightness.dark,
        cardTheme: const CardTheme(
          shadowColor: Colors.white,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.white),
          ),
        ),
      ),
      title: 'Wuether',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/info': (context) => const InfoPage(),
        '/search': (context) => const SearchPage(),
        '/favourite': (context) => const FavouritesPage(),
        '/settings': (context) => const SettingsPage(),
        '/week': (context) => const WeeklyForecastPage(),
      },
    );
  }
}