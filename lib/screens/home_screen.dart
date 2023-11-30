import 'package:flutter/material.dart';
import 'package:melodymap/services/genius_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GeniusApiService _geniusApiService = GeniusApiService(
      "MBmA354Etaa1Y40-kRHSPyrV9ZGUepLNqOyZF-2oEg2eruVz8HvRj58-ffP1oyRk"); // Replace with your actual access token

  String _lyrics = '';
  final TextEditingController _searchController = TextEditingController();

  void _fetchLyrics() async {
    String? lyrics = await _geniusApiService.fetchLyrics(
      _searchController.text,
      _searchController.text,
    );
    setState(() {
      _lyrics = lyrics ?? 'Lyrics not found';
    });

    if (lyrics != null) {
      // Navigate to LyricsPage when lyrics are found
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LyricsPage(lyrics),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lyrics Finder')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Favorites'),
              onTap: () {
                Navigator.of(context).pushNamed('/favorites');
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Song',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _fetchLyrics,
                ),
              ),
              onSubmitted: (value) => _fetchLyrics(),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      _lyrics,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LyricsPage extends StatelessWidget {
  final String lyrics;

  LyricsPage(this.lyrics);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lyrics Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            lyrics,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
