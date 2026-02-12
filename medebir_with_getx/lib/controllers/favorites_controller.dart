import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medebir_with_getx/controllers/auth_controller.dart';
import 'package:medebir_with_getx/helper/database_helper.dart';
import 'package:medebir_with_getx/models/book.dart';

class FavoritesController extends GetxController {
  List<Book> _favoriteBooksList = [];
  List<Book> get favoriteBooksList => _favoriteBooksList;

  @override
  void onInit() async {
    _favoriteBooksList = await DatabaseHelper.instance.getFavoritesList();
    update();
    super.onInit();
  }

  void addToFavorites(Book book) async {
    if (!_favoriteBooksList.contains(book)) {
      try {
        await DatabaseHelper.instance.inserFavoriteBook(book);
        AuthController.showSnackBar(title: "Wishlist", message: "${book.title} added to wishlist.", bgColor: Colors.black, txtColor: Colors.white);
        _favoriteBooksList = await DatabaseHelper.instance.getFavoritesList();
      } catch (e) {
        AuthController.showSnackBar(title: "Error", message: "${e.message}", bgColor: Colors.black, txtColor: Colors.white);
      }
    } else {
      AuthController.showSnackBar(title: "Wishlist", message: "${book.title} is already in the wishlist", bgColor: Colors.black, txtColor: Colors.white);
    }
    update();
  }

//TODO:removing from favorite
  void removeFromFavorites(Book book) async {
    if (_favoriteBooksList.contains(book)) {
      try {
        await DatabaseHelper.instance.removeFavoriteBook(book);
        _favoriteBooksList = await DatabaseHelper.instance.getFavoritesList();
      } catch (e) {
        // AuthController.showSnackBar(title: "Error", message: "${e.message}", bgColor: Colors.black, txtColor: Colors.white);
        AuthController.showSnackBar(title: "Already Added", message: "Book already added", bgColor: Colors.black, txtColor: Colors.white);
      }
    }
    update();
  }
}
