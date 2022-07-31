import 'package:flutter/material.dart';
import 'package:inventory_management/database/database.dart';
import 'package:inventory_management/models/category.dart';
import 'package:inventory_management/widgets/general_list.dart';

import '../constants.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _addCategoryFormKey = GlobalKey<FormState>();
  String category = '';
  List<Category> categoryList = [];

  @override
  void initState() {
    mapToList(categoryTable);
    super.initState();
  }

  Future<void> mapToList(String tableName) async {
    final db = await DatabaseHelper.instance;
    final allData = await db.selectAll(tableName);
    setState(
      () {
        for (var row in allData) {
          categoryList.add(
            Category(
              id: row[CategoryFields.id],
              categoryName: row[CategoryFields.name],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Form(
              key: _addCategoryFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        category = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty || value == null) {
                        return 'Please enter category';
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Category name',
                      label: Text('Category name'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_addCategoryFormKey.currentState!.validate()) {
                          final db = DatabaseHelper.instance;
                          await db.addData(
                            categoryTable,
                            {CategoryFields.name: category},
                          );
                          setState(() {
                            categoryList = [];
                          });
                          mapToList(categoryTable);
                        }
                      },
                      child: const Text(
                        'Add',
                        style: kButtonTextStyle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'List of cat',
                    style: kHintTextStyle,
                  ),
                  SizedBox(
                    height: (MediaQuery.of(context).size.height * 0.60) - 20,
                    child: ListView.builder(
                      itemCount: categoryList.length,
                      itemBuilder: (context, index) {
                        return GeneralList(
                          title: categoryList[index].categoryName,
                          onDeleteButtonPressed: () async {
                            final db = DatabaseHelper.instance;
                            final int foo = await db.delete(
                                categoryList[index].id, categoryTable);
                            if (foo == 1) {
                              setState(() {
                                categoryList = [];
                              });
                              mapToList(categoryTable);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'Something went wrong can not delete the item'),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
