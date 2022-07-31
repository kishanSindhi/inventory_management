import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_management/models/category.dart';
import 'package:inventory_management/models/product.dart';
import 'package:inventory_management/screens/products_screen.dart';

import '../database/database.dart';
import '../models/company.dart';
import '../widgets/add_image_button.dart';
import '../widgets/dropdown_list.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({
    Key? key,
    required this.product,
  }) : super(key: key);
  final Product product;
  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _addProductFormKey = GlobalKey<FormState>();
  String? productName;
  String? category;
  String? companyName;
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
        title: const Text('Edit Product'),
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
                initialValue: widget.product.name,
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
                title: category ?? widget.product.category,
                onChanged: (value) {
                  setState(() {
                    category = value;
                  });
                },
              ),
              DropDownList(
                items: companyList,
                title: companyName ?? widget.product.companyName,
                onChanged: (value) {
                  setState(() {
                    companyName = value;
                  });
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: TextFormField(
                  initialValue: widget.product.description,
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
                initialValue: widget.product.price,
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
                initialValue: widget.product.quantity,
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
                      final db = DatabaseHelper.instance;
                      final foo = await db.update({
                        ProductFields.id: widget.product.id,
                        ProductFields.name: productName ?? widget.product.name,
                        ProductFields.category:
                            category ?? widget.product.category,
                        ProductFields.companyName:
                            companyName ?? widget.product.companyName,
                        ProductFields.description:
                            description ?? widget.product.description,
                        ProductFields.price: price ?? widget.product.price,
                        ProductFields.quantity: qty ?? widget.product.quantity,
                        ProductFields.image: imageList ?? widget.product.image,
                      }, tableInventory);
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
                    'Save Changes',
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
