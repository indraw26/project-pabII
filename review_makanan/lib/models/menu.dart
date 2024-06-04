class MenuItem {
  String? id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String restaurantId;

  MenuItem({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.restaurantId,
  });

  factory MenuItem.fromMap(Map<String, dynamic> data, String documentId) {
    return MenuItem(
      id: documentId,
      name: data['name'],
      description: data['description'],
      price: data['price'],
      imageUrl: data['image_url'],
      restaurantId: data['restaurant_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'restaurant_id': restaurantId,
    };
  }
}
