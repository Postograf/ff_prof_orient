import 'package:ff_to_play_dota_2/api_workers/cities_searcher.dart';
import 'package:ff_to_play_dota_2/models/cities_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'dart:developer' as dev;

import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget{
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{
  final _searchFocus = FocusNode();
  final _searchController = TextEditingController();

  Future<List<SearchResult>> cityList = Future.value([]);

  @override
  void initState() {
    super.initState();
    _searchFocus.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchCities() {
    if (_searchController.text.isEmpty) {
      return;
    }

    setState(() {
      cityList = searchCities(_searchController.text, 20);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: TextField(
          focusNode: _searchFocus,
          controller: _searchController,
          onEditingComplete: _fetchCities,
          style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).textTheme.subtitle1!.color,
          ),
          decoration: const InputDecoration(
            hintText: 'Введите город',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
                Icons.close,
                color: Theme.of(context).iconTheme.color,
            ),
            onPressed: _searchController.clear,
          ),
        ],
      ),
      body: FutureBuilder<List<SearchResult>>(
        future: cityList,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            dev.log('Error: ${snapshot.error}');
            return const Center(child: Text('Не удалось получить результаты'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var weather = context.read<CitiesModel>();
              var item = snapshot.data![index];
              var isFavorite = context.read<CitiesModel>().favoriteCities.contains(item.city);

              return SearchListTile(weather, item, isFavorite);
            },
          );
        },
      ),
    );
  }
}

class SearchListTile extends StatefulWidget{
  final CitiesModel weather;
  final SearchResult item;
  final bool isFavorite;

  const SearchListTile(this.weather, this.item, this.isFavorite, {Key? key}) : super(key: key);

  @override
  State<SearchListTile> createState() => SearchListTileState();
}

class SearchListTileState extends State<SearchListTile> {
  late CitiesModel weather;
  late SearchResult item;
  late bool isFavorite;
  late Icon icon;

  @override
  void initState() {
    super.initState();

    weather = widget.weather;
    item = widget.item;
    isFavorite = widget.isFavorite;
    icon = Icon(isFavorite ? Icons.star : Icons.star_border);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${item.city} - ${item.country}'),
      trailing: IconButton(
        icon: icon,
        onPressed: () {
          setState(() {
            if (icon.icon == Icons.star_border){
              icon = const Icon(Icons.star);
              weather.addFavoriteCity(item.city);
            }
            else {
              icon = const Icon(Icons.star_border);
              weather.removeFavoriteCity(item.city);
            }
          });
        },
      ),
      onTap: () {
        weather.currentCity = item.city;
        Navigator.pop(context);
      },
    );
  }
}