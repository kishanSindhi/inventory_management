const categoryTable = 'category';

class CategoryFields {
  static const id = '_id';
  static const name = 'categoryName';
}

class Category {
  final int id;
  final String categoryName;

  Category({
    required this.id,
    required this.categoryName,
  });
}
