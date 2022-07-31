import 'package:flutter/material.dart';
import 'package:inventory_management/database/database.dart';
import 'package:inventory_management/widgets/general_list.dart';

import '../constants.dart';
import '../models/company.dart';

class AddCompany extends StatefulWidget {
  const AddCompany({Key? key}) : super(key: key);

  @override
  State<AddCompany> createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  final _addCompanyFormKey = GlobalKey<FormState>();
  String company = '';
  List<Company> companyList = [];

  @override
  void initState() {
    mapToList(companyTable);
    super.initState();
  }

  Future<void> mapToList(String tableName) async {
    final db = await DatabaseHelper.instance;
    final allData = await db.selectAll(tableName);
    setState(
      () {
        for (var row in allData) {
          companyList.add(
            Company(
              id: row[CompanyFields.id],
              companyName: row[CompanyFields.name],
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
        title: const Text('Company'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Form(
              key: _addCompanyFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        company = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty || value == null) {
                        return 'Please enter company';
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Company name',
                      label: Text('Company name'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_addCompanyFormKey.currentState!.validate()) {
                          final db = DatabaseHelper.instance;
                          await db.addData(
                            companyTable,
                            {CompanyFields.name: company},
                          );
                          setState(() {
                            companyList = [];
                          });
                          mapToList(companyTable);
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
                    'List of company',
                    style: kHintTextStyle,
                  ),
                  SizedBox(
                    height: (MediaQuery.of(context).size.height * 0.60) - 20,
                    child: ListView.builder(
                      itemCount: companyList.length,
                      itemBuilder: (context, index) {
                        return GeneralList(
                          title: companyList[index].companyName,
                          onDeleteButtonPressed: () async {
                            final db = DatabaseHelper.instance;
                            final int foo = await db.delete(
                                companyList[index].id, companyTable);
                            if (foo == 1) {
                              setState(() {
                                companyList = [];
                              });
                              mapToList(companyTable);
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
