import 'package:flutter/material.dart';
import 'package:review_makanan/models/menu.dart';
import 'package:review_makanan/models/restaurant.dart';
import 'package:review_makanan/services/menu_service.dart';
import 'package:review_makanan/widgets/widget_menu.dart';

class MenuRestoScreen extends StatelessWidget {
  final Restaurant resto;

  const MenuRestoScreen({super.key, required this.resto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(resto.nama),
        backgroundColor: const Color(0xfffc88ff),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return TambahMenuScreen(restaurantId: resto.id!);
            },
          );
        },
        tooltip: 'Add Menu',
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<MenuItem>>(
        stream: MenuService.getMenuItemsByRestaurant(resto.id!),
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
                        resto.nama,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Dalam proses penyajian minuman, Chatime menggunakan teh berkualitas terbaik yang diolah menggunakan brewing machine terbaru. Mengadopsi konsep penyajian customized drink, pelanggan Chatime dapat menentukan sendiri jenis topping dan takaran gula, serta jumlah es yang diinginkan. Chatime juga selalu berinovasi dengan menghadirkan menu terbaru.',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Menu',
                        style: Theme.of(context).textTheme.headline6,
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
                          return Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                      Text(
                                        menuItem.description,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${menuItem.price} \$',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                          ),
                                          const Icon(Icons.favorite_border),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
