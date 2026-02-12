import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medebir_with_getx/models/book.dart';

class ApiController extends GetxController {
  RxList<Book> _booksList = RxList<Book>();

  List<Book> get booksList => _booksList;
  //
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void getData() async {
    var uri = Uri.parse("https://bookapi.rentoch.com/books");
    var response = await http.get(uri);
    var jsonData = jsonDecode(response.body);
    for (int i = 0; i < jsonData.length; i++) {
      _booksList.add(Book.fromJson(jsonData[i]));
    }
    update();
  }
}
