import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:review_makanan/models/restaurant.dart';
import 'package:review_makanan/screens/home.dart';
import 'package:review_makanan/screens/settings.dart';
import 'package:review_makanan/services/restaurant_services.dart';

class TambahRestoScreen extends StatefulWidget {
  final Restaurant? resto;
  const TambahRestoScreen({super.key, this.resto});

  @override
  State<TambahRestoScreen> createState() => _TambahRestoScreenState();
}

class _TambahRestoScreenState extends State<TambahRestoScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.resto != null) {
      _namaController.text = widget.resto!.nama;
      _alamatController.text = widget.resto!.alamat;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String? imageUrl;

      try {
        if (_imageFile != null) {
          imageUrl = await RestaurantService.uploadImage(_imageFile!);
        }

        Restaurant newRestaurant = Restaurant(
          id: widget.resto?.id,
          nama: _namaController.text,
          alamat: _alamatController.text,
          imageUrl: imageUrl ?? widget.resto?.imageUrl,
          createdAt: widget.resto?.createdAt,
          updatedAt: null,
        );

        if (widget.resto == null) {
          await RestaurantService.addRestaurant(newRestaurant);
        } else {
          await RestaurantService.updateRestaurant(newRestaurant);
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Restorant berhasil Tambah!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pop();
      } catch (e) {
        setState(() {});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save restorant: $e'),
            backgroundColor: Colors.red,
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Tambah Restorant',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingScreen()));
            },
          )
        ],
        backgroundColor: Color(0xfffc88ff),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(30.0),
                child: ListView(
                  children: [
                    const Text(
                      'Nama Restorant',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _namaController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Masukkan Nama Restorant";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Alamat Restorant',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _alamatController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Masukkan Alamat Restorant";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Image:',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _imageFile != null
                        ? Image.network(
                            _imageFile!.path,
                            fit: BoxFit.cover,
                          )
                        : (widget.resto?.imageUrl != null &&
                                Uri.parse(widget.resto!.imageUrl!).isAbsolute
                            ? Image.network(
                                widget.resto!.imageUrl!,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Text('No image selected.'),
                                ),
                              )),
                    TextButton(
                      onPressed: _pickImage,
                      child: const Text('Pick Image'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        String? imageUrl;
                        if (_imageFile != null) {
                          imageUrl = await RestaurantService.uploadImage(_imageFile!);
                        } else {
                          imageUrl = widget.resto?.imageUrl;
                        }
                        Restaurant resto = Restaurant(
                          id: widget.resto?.id,
                          nama: _namaController.text,
                          alamat: _alamatController.text,
                          imageUrl: imageUrl,
                          createdAt: widget.resto?.createdAt,
                        );

                        if (widget.resto == null) {
                          RestaurantService.addRestaurant(resto)
                              .whenComplete(() => Navigator.of(context).pop());
                        } else {
                          RestaurantService.updateRestaurant(resto)
                              .whenComplete(() => Navigator.of(context).pop());
                        }
                      },
                      child: Text(widget.resto == null ? 'Add' : 'Update'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
