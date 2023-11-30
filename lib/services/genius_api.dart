import 'package:genius_lyrics/genius_lyrics.dart';

Genius genius = Genius(
    accessToken:
        "MBmA354Etaa1Y40-kRHSPyrV9ZGUepLNqOyZF-2oEg2eruVz8HvRj58-ffP1oyRk");

class GeniusApiService {
  final String accessToken;

  GeniusApiService(this.accessToken);

  Future<String?> fetchLyrics(String artistName, String songTitle) async {
    try {
      final genius = Genius(accessToken: accessToken);

      final song =
          await genius.searchSong(artist: artistName, title: songTitle);

      if (song != null) {
        return song.lyrics;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching lyrics: $e');
      return null;
    }
  }
}
