import 'dart:async';

import 'package:inventory_management/models/category.dart';
import 'package:inventory_management/models/company.dart';
import 'package:inventory_management/models/product.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // created a single ton constructor so that it do not create db again and again
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    // getting the database
    // DO NOT USE IF ELSE CONDITION EVER
    if (_database != null) return _database!;

    _database = await _initDB('inventoryDataBase.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // creating the database
    final dbPath = await getDatabasesPath(); //get the database path
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

  Future<void> _onCreateDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const stringType = 'TEXT NOT NULL';
    // Creating the required tables
    // the tables will be created when the database will created
    await db.execute('''
      CREATE TABLE $tableInventory (
        ${ProductFields.id} $idType,
        ${ProductFields.name} $stringType,
        ${ProductFields.category} $stringType,
        ${ProductFields.companyName} $stringType,
        ${ProductFields.description} $stringType,
        ${ProductFields.price} $stringType,
        ${ProductFields.quantity} $stringType,
        ${ProductFields.image} $stringType)
''');
    await db.execute('''
      CREATE TABLE $companyTable (
        ${CompanyFields.id} $idType,
        ${CompanyFields.name} $stringType)
''');
    await db.execute('''
      CREATE TABLE $categoryTable (
        ${CategoryFields.id} $idType,
        ${CategoryFields.name} $stringType)
''');
  }

  Future<int> addData(String tableName, Map<String, dynamic> row) async {
    // adding data to the database
    final db = await instance.database;
    int updatedRows = await db.insert(tableName, row);

    return updatedRows;
  }

  Future<List<Map<String, dynamic>>> selectAll(String tableName) async {
    // select all method
    final db = await instance.database;
    List<Map<String, dynamic>> rows = await db.query(tableName);

    return rows;
  }

  Future<int> update(Map<String, dynamic> row, String tableName) async {
    final db = await instance.database;
    int updatedRows = await db.update(
      tableName,
      row,
      where: '${ProductFields.id} = ?',
      whereArgs: [row[ProductFields.id]],
    );

    return updatedRows;
  }

  Future<int> delete(int id, String tableName) async {
    final db = await instance.database;
    final updatedRows =
        await db.delete(tableName, where: '_id = ?', whereArgs: [id]);
    return updatedRows;
  }

  Future<void> close() async {
    // closing the database i.e releasing the resources
    final db = await instance.database;
    db.close();
  }
}
