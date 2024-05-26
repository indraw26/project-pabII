import 'package:flutter/material.dart';
import 'package:review_makanan/screens/detail.dart';
import 'package:review_makanan/services/restaurant_services.dart';
import 'package:review_makanan/widgets/restaurant.dart';
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
            icon: const Icon(Icons.settings,color: Colors.white,),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SettingScreen()));
            },
          )
        ],
        backgroundColor: Color(0xfffc88ff),
      ),
      body: RestorantScreen(),
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
    return StreamBuilder(
      stream: RestaurantService.getRestaurantList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            return ListView(
              padding: const EdgeInsets.only(bottom: 80),
              children: snapshot.data!.map((document) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DetailScreen(resto: document);
                        },
                      );
                    },
                    child: Column(
                      children: [
                        document.imageUrl != null && Uri.parse(document.imageUrl!).isAbsolute
                            ? ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                child: Image.network(
                                  document.imageUrl!,
                                  alignment: Alignment.center,
                                  width: 50,
                                  height: 50,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
        }
      },
    );;
  }
}
