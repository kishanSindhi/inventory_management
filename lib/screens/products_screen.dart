import 'package:flutter/material.dart';
import 'package:inventory_management/database/database.dart';
import 'package:inventory_management/models/product.dart';
import 'package:inventory_management/screens/add_products.dart';
import 'package:inventory_management/widgets/product_list_tile.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> productList = [];
  @override
  void initState() {
    addProductToList();
    super.initState();
  }

  Future<void> addProductToList() async {
    final db = DatabaseHelper.instance;
    final products = await db.selectAll(tableInventory);
    for (var row in products) {
      setState(() {
        productList.add(Product(
          name: row[ProductFields.name],
          category: row[ProductFields.category],
          companyName: row[ProductFields.companyName],
          description: row[ProductFields.description],
          price: row[ProductFields.price],
          quantity: row[ProductFields.quantity],
          image: row[ProductFields.image],
          id: row[ProductFields.id],
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProductScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, index) {
          return ProductListTile(
            product: productList[index],
            deleteButtonOnPressed: () async {
              final db = DatabaseHelper.instance;
              final foo = await db.delete(
                productList[index].id!,
                tableInventory,
              );
              if (foo == 1) {
                setState(() {
                  productList = [];
                });
                addProductToList();
              }
            },
          );
        },
      ),
    );
  }
}
