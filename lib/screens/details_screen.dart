import 'package:flutter/material.dart';
import 'package:inventory_management/database/database.dart';
import 'package:inventory_management/models/product.dart';
import 'package:inventory_management/screens/edit_product_screen.dart';
import 'package:inventory_management/screens/products_screen.dart';
import 'package:inventory_management/widgets/image_slider.dart';

import '../constants.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({
    Key? key,
    required this.product,
  }) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Details Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const ImageSlider(),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: kHeadingTextStyle,
                        ),
                        Text(
                          product.category,
                          style: kHintTextStyle,
                        ),
                      ],
                    ),
                    Text(
                      'Price ${product.price}/-',
                      style: kHeadingTextStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.companyName,
                      style: kHeadingTextStyle,
                    ),
                    Text(
                      'Qty - ${product.quantity}',
                      style: kHeadingTextStyle,
                    ),
                  ],
                ),
              ],
            ),
            const Text(
              'Description',
              style: kHeadingTextStyle,
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: SingleChildScrollView(
                child: Text(
                  product.description,
                  style: kDescriptionTextStyle,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProduct(product: product),
                          ),
                        );
                      },
                      child: const Text('Edit'),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        final db = DatabaseHelper.instance;
                        final foo =
                            await db.delete(product.id!, tableInventory);
                        if (foo == 1) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProductScreen(),
                            ),
                          );
                        }
                      },
                      child: const Text('Delete'),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
