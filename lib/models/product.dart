const String tableInventory = 'inventory';

class ProductFields {
  static const String id = '_id';
  static const String name = 'name';
  static const String category = 'category';
  static const String companyName = 'companyName';
  static const String description = 'description';
  static const String price = 'price';
  static const String quantity = 'quantity';
  static const String image = 'image';
}

class Product {
  final int? id;
  final String name;
  final String category;
  final String companyName;
  final String description;
  final String price;
  final String quantity;
  final String image;

  Product({
    this.id,
    required this.name,
    required this.category,
    required this.companyName,
    required this.description,
    required this.price,
    required this.quantity,
    required this.image,
  });
}
