import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:review_makanan/models/menu.dart';
import 'package:review_makanan/services/menu_service.dart';

class TambahMenuScreen extends StatefulWidget {
  final String restaurantId;

  const TambahMenuScreen({super.key, required this.restaurantId});

  @override
  _TambahMenuScreenState createState() => _TambahMenuScreenState();
}

class _TambahMenuScreenState extends State<TambahMenuScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _description;
  double? _price;
  String? _imageUrl;

  final ImagePicker _picker = ImagePicker();

  void _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? imageUrl = await MenuService.uploadImage(image);
      setState(() {
        _imageUrl = imageUrl;
      });
    }
  }

  void _saveMenu() async {
    if (_formKey.currentState!.validate() && _imageUrl != null) {
      _formKey.currentState!.save();
      MenuItem newMenuItem = MenuItem(
        name: _name!,
        description: _description!,
        price: _price!,
        imageUrl: _imageUrl!,
        restaurantId: widget.restaurantId,
      );
      await MenuService.addMenuItem(newMenuItem);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tambah Menu'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nama Menu'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama menu tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Harga Menu'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga menu tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Harga menu harus berupa angka';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = double.parse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Deskripsi Menu'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi menu tidak boleh kosong';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value;
                },
              ),
              const SizedBox(height: 10),
              _imageUrl != null
                  ? Image.network(_imageUrl!, height: 150)
                  : Container(),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pilih Gambar'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _saveMenu,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}
