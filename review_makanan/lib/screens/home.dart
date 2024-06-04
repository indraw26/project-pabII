import 'package:flutter/material.dart';
import 'package:review_makanan/models/restaurant.dart';
import 'package:review_makanan/screens/detail.dart';
import 'package:review_makanan/screens/menu.dart';
import 'package:review_makanan/services/restaurant_services.dart';
import 'package:review_makanan/widgets/widget_restaurant.dart';
import 'package:review_makanan/screens/settings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Beranda',
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
      body: const RestorantScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return const TambahRestoScreen();
            },
          );
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class RestorantScreen extends StatelessWidget {
  const RestorantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Restaurant>>(
      stream: RestaurantService.getRestaurantList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            return ListView(
              padding: const EdgeInsets.only(bottom: 20),
              children: snapshot.data!.map<Widget>((restaurant) {
                return SizedBox(
                  child: Container(
                    height: 150,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 70.0, vertical: 14.0),
                    child: Card(
                      color: const Color(0xfffc88ff),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MenuRestoScreen(resto: restaurant),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            restaurant.imageUrl != null &&
                                    Uri.parse(restaurant.imageUrl!).isAbsolute
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      restaurant.imageUrl!,
                                      alignment: Alignment.center,
                                      height: 150,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      restaurant.nama,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      restaurant.alamat,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
