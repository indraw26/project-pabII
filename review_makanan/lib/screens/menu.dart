import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:review_makanan/models/menu.dart';
import 'package:review_makanan/models/restaurant.dart';
import 'package:review_makanan/screens/comment.dart';
import 'package:review_makanan/services/favorite_service.dart';
import 'package:review_makanan/services/menu_service.dart';
import 'package:review_makanan/widgets/widget_menu.dart';
import 'package:intl/intl.dart';

class MenuRestoScreen extends StatefulWidget {
  final Restaurant resto;

  const MenuRestoScreen({super.key, required this.resto});

  @override
  _MenuRestoScreenState createState() => _MenuRestoScreenState();
}

class _MenuRestoScreenState extends State<MenuRestoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.resto.nama),
        backgroundColor: const Color(0xfffc88ff),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return TambahMenuScreen(restaurantId: widget.resto.id!);
            },
          );
        },
        tooltip: 'Add Menu',
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<MenuItem>>(
        stream: MenuService.getMenuItemsByRestaurant(widget.resto.id!),
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
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXAQFjmAS04ANtPdfjnpnbNSB4kRrdAy5MgPBnd8jyTg6QrjcX',
                  width: 500,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.resto.nama,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Dalam proses penyajian minuman, Chatime menggunakan teh berkualitas terbaik yang diolah menggunakan brewing machine terbaru. Mengadopsi konsep penyajian customized drink, pelanggan Chatime dapat menentukan sendiri jenis topping dan takaran gula, serta jumlah es yang diinginkan. Chatime juga selalu berinovasi dengan menghadirkan menu terbaru.',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Menu',
                      ),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final menuItem = snapshot.data![index];
                          return FutureBuilder<bool>(
                            future: FavoriteService.isFavorite(menuItem),
                            builder: (context, favoriteSnapshot) {
                              if (favoriteSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              bool isFavorite = favoriteSnapshot.data ?? false;
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CommentScreen(menuItem: menuItem),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Image.network(
                                          menuItem.imageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              menuItem.name,
                                            ),
                                            Text(
                                              menuItem.description,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(menuItem.price)}',
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    isFavorite
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: isFavorite
                                                        ? Colors.red
                                                        : null,
                                                  ),
                                                  onPressed: () async {
                                                    if (isFavorite) {
                                                      await FavoriteService
                                                          .removeFavorite(
                                                              menuItem);
                                                    } else {
                                                      await FavoriteService
                                                          .addFavorite(
                                                              menuItem);
                                                    }
                                                    // Update the UI
                                                    setState(() {});
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
