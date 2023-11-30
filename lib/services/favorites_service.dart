import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _keyFavorites = 'favorites';

  final SharedPreferences _prefs;

  FavoritesService(this._prefs);

  Future<List<String>> getFavorites() async {
    try {
      return _prefs.getStringList(_keyFavorites) ?? <String>[];
    } catch (e) {
      print('Error getting favorites: $e');
      return <String>[];
    }
  }

  Future<void> addFavorite(String lyric) async {
    try {
      final favorites = await getFavorites();
      if (!favorites.contains(lyric)) {
        favorites.add(lyric);
        await _prefs.setStringList(_keyFavorites, favorites);
      }
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  Future<void> removeFavorite(String lyric) async {
    try {
      final favorites = await getFavorites();
      favorites.remove(lyric);
      await _prefs.setStringList(_keyFavorites, favorites);
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }
}

// Example of using FavoritesService
void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  FavoritesService favoritesService = FavoritesService(prefs);

  // Example usage
  List<String> favorites = await favoritesService.getFavorites();
  print('Favorites: $favorites');

  await favoritesService.addFavorite('Favorite Lyric 1');
  await favoritesService.addFavorite('Favorite Lyric 2');

  favorites = await favoritesService.getFavorites();
  print('Updated Favorites: $favorites');

  await favoritesService.removeFavorite('Favorite Lyric 1');

  favorites = await favoritesService.getFavorites();
  print('Final Favorites: $favorites');
}
