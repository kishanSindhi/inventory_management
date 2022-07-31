import 'package:flutter/material.dart';
import 'package:inventory_management/screens/add_category.dart';
import 'package:inventory_management/screens/add_company.dart';
import 'package:inventory_management/screens/products_screen.dart';

import '../widgets/button_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ButtonCard(
              title: 'Products',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProductScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            ButtonCard(
              title: 'Manage Category',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddCategory(),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            ButtonCard(
              title: 'Manage Company',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddCompany(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
