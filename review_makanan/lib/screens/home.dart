import 'package:flutter/material.dart';
import 'package:review_makanan/screens/detail.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Beranda',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.settings, color: Colors.white),
          ),
        ],
        backgroundColor: Color(0xfffc88ff),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0), // Tambahkan padding di sini
        child: Container(
          alignment: Alignment.center,
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 150.0,
                  margin: EdgeInsets.symmetric(horizontal: 70.0),
                  child: Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'images/logo.png',
                            height: 200,
                          ),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Nama Restorant',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text('Alamat Restaurant'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
