import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medebir_with_getx/controllers/auth_controller.dart';
import 'package:medebir_with_getx/models/book.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final String tableName = 'favoriteTable';
final String sId = "sId";
final String title = 'title';
final String category = 'category';
final String description = 'description';
final String author = "author";
final String rating = 'rating';
final String price = 'price';
final String posterImage = 'posterImage';
final String posterPublicId = "posterPublicId";
final String postDate = 'postDate';
final String iV = 'iV';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;
  DatabaseHelper._instance();

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "favorites.db";
    final favoritesDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return favoritesDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $tableName (
          $sId TEXT PRIMARY KEY NOT NULL,
          $title TEXT  NOT NULL,
          $category TEXT NOT NULL,
          $description TEXT NOT NULL,
          $author TEXT NOT NULL,
          $rating TEXT NOT NULL,
          $price TEXT NOT NULL,
          $posterImage TEXT NOT NULL,
          $posterPublicId TEXT NOT NULL,
          $postDate TEXT NOT NULL,
          $iV INTEGER)
    ''');
  }

  Future<List<Map<String, dynamic>>> getFavoritesMapList() async {
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(tableName);
    return result;
  }

  Future<List<Book>> getFavoritesList() async {
    List<Map<String, dynamic>> favoritesMapList = await getFavoritesMapList();
    final List<Book> favoritesList = [];
    favoritesMapList.forEach((budgetMap) {
      favoritesList.add(Book.fromMap(budgetMap));
    });
    return favoritesList;
  }

  Future<int> inserFavoriteBook(Book book) async {
    try {
      Database db = await this.db;
      final int result = await db.insert(tableName, book.toMap());
      print("$book has been inserted");
      List<Book> books = await getFavoritesList();
      print(books);
      return result;
    } catch (e) {
      print(e.message);
      // AuthController.showSnackBar(title: "Error while inserting to Db", message: e.message, bgColor: Colors.black, txtColor: Colors.white);
      AuthController.showSnackBar(title: "Already Added", message: "Book already added", bgColor: Colors.black, txtColor: Colors.white);
    }
    return 1;
  }

//TODO:removing from favorite
  Future<int> removeFavoriteBook(Book book) async {
    try {
      Database db = await this.db;
      final int result = await db.delete(tableName, where: "$sId = ?", whereArgs: [book.sId]);
      print("$book has been removed");
      return result;
    } catch (error) {
      print(error);
      // AuthController.showSnackBar(title: "Error while removing from Db", message: error.message, bgColor: Colors.black, txtColor: Colors.white);
      AuthController.showSnackBar(title: "Already Added", message: "Book already added", bgColor: Colors.black, txtColor: Colors.white);
    }
    return 1;
  }
}
