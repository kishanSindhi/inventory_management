import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_management/models/category.dart';
import 'package:inventory_management/models/product.dart';
import 'package:inventory_management/screens/products_screen.dart';

import '../database/database.dart';
import '../models/company.dart';
import '../widgets/add_image_button.dart';
import '../widgets/dropdown_list.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _addProductFormKey = GlobalKey<FormState>();
  String? productName;
  String? category = 'Category';
  String? companyName = 'Company name';
  String? description;
  String? price;
  String? qty;
  String? imageList;
  List<dynamic> images = [];
  List<String> companyList = [];
  List<String> categoryList = [];

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      final image = await file.readAsBytes();
      setState(() {
        images.add(image);
        imageList = images.toString();
      });
    }
  }

  Future<void> selectImage() async {
    await pickImage(ImageSource.gallery);
  }

  Future<void> companyListGenerator(String tableName) async {
    final db = await DatabaseHelper.instance;
    final allData = await db.selectAll(tableName);
    setState(
      () {
        for (var row in allData) {
          companyList.add(
            row[CompanyFields.name],
          );
        }
      },
    );
  }

  Future<void> categoryListGenerator(
    String tableName,
  ) async {
    final db = await DatabaseHelper.instance;
    final allData = await db.selectAll(tableName);
    setState(
      () {
        for (var row in allData) {
          categoryList.add(
            row[CategoryFields.name],
          );
        }
      },
    );
  }

  @override
  void initState() {
    companyListGenerator(companyTable);
    categoryListGenerator(categoryTable);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Add Products'),
      ),
      body: Form(
        key: _addProductFormKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    productName = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty || value == null) {
                    return 'Enter product name';
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Product Name',
                  label: Text('Product Name'),
                ),
              ),
              DropDownList(
                items: categoryList,
                title: category!,
                onChanged: (value) {
                  setState(() {
                    category = value;
                  });
                },
              ),
              DropDownList(
                items: companyList,
                title: companyName!,
                onChanged: (value) {
                  setState(() {
                    companyName = value;
                  });
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty || value == null) {
                      return 'Enter product description';
                    }
                  },
                  maxLines: 20,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Description',
                    label: Text('Description'),
                  ),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    price = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty || value == null) {
                    return 'Enter product price';
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Price',
                  label: Text('Price'),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    qty = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty || value == null) {
                    return 'Enter product quantity';
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Qty',
                  label: Text('Qty'),
                ),
              ),
              const Text('Upload Image'),
              Row(
                children: [
                  AddImageButton(
                    onTap: () async {
                      await selectImage();
                    },
                  ),
                  const SizedBox(width: 5),
                  AddImageButton(
                    onTap: () async {
                      await selectImage();
                    },
                  ),
                  const SizedBox(width: 5),
                  AddImageButton(
                    onTap: () async {
                      await selectImage();
                    },
                  ),
                  const SizedBox(width: 5),
                  AddImageButton(
                    onTap: () async {
                      await selectImage();
                    },
                  ),
                ],
              ),
              const Text(
                'Minimum 2 images',
                textAlign: TextAlign.right,
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_addProductFormKey.currentState!.validate()) {
                      final db = await DatabaseHelper.instance;
                      final foo = await db.addData(tableInventory, {
                        ProductFields.name: productName,
                        ProductFields.category: category,
                        ProductFields.companyName: companyName,
                        ProductFields.description: description,
                        ProductFields.price: price,
                        ProductFields.quantity: qty,
                        ProductFields.image: imageList,
                      });
                      if (foo != 0) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductScreen(),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
