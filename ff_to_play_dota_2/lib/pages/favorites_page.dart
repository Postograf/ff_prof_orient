import 'package:ff_to_play_dota_2/models/cities_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

class FavouritesPage extends StatefulWidget{
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage>{
  @override
  Widget build(BuildContext context) {
    var favorites = context.watch<CitiesModel>().favoriteCities;

    return Scaffold(
      appBar: NeumorphicAppBar(
        title: const Text('Избранные города'),
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Neumorphic(
              style: NeumorphicStyle(
                color: NeumorphicTheme.variantColor(context),
                depth: -5,
              ),
              child: ListTile(
                title: Text(favorites[index]),
                trailing: NeumorphicButton(
                  style: NeumorphicStyle(
                    color: NeumorphicTheme.variantColor(context).withOpacity(0.2),
                  ),
                  child: const Icon(Icons.close),
                  onPressed: () {
                    context.read<CitiesModel>().removeFavoriteCity(favorites[index]);
                  },
                ),
                onTap: () {
                  context.read<CitiesModel>().currentCity = favorites[index];
                  Navigator.pop(context);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}