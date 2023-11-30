import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:melodymap/services/favorites_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoritesService _favoritesService;
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _initializeFavorites();
  }

  Future<void> _initializeFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _favoritesService = FavoritesService(prefs);
    await _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _favoritesService.getFavorites();
    setState(() {
      _favorites = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final lyric = _favorites[index];
          return ListTile(
            title: Text(lyric),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _favoritesService.removeFavorite(lyric);
                await _loadFavorites();
              },
            ),
          );
        },
      ),
    );
  }
}
