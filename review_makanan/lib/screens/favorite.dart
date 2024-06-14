import 'package:flutter/material.dart';
import 'package:review_makanan/models/menu.dart';
import 'package:review_makanan/screens/settings.dart';
import 'package:review_makanan/services/favorite_service.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<MenuItem>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    _favoritesFuture = FavoriteService.getFavorites();
  }

  void _removeFavorite(MenuItem menuItem) async {
    await FavoriteService.removeFavorite(menuItem);
    setState(() {
      _loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Favorite',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingScreen()));
            },
          )
        ],
        backgroundColor: const Color(0xfffc88ff),
      ),
      body: FutureBuilder<List<MenuItem>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No favorites added yet.'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final menuItem = snapshot.data![index];
              return Card(
                child: ListTile(
                  leading: Image.network(
                    menuItem.imageUrl,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(menuItem.name),
                  subtitle: Text(menuItem.description),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => _removeFavorite(menuItem),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
