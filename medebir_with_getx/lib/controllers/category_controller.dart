import 'package:get/get.dart';
import 'package:medebir_with_getx/controllers/api_controller.dart';
import 'package:medebir_with_getx/models/book.dart';

class CategoryController extends GetxController {
  ApiController _apiController = Get.find<ApiController>();

  List<String> _categories = ["Fiction", "Educational", "Non-Fiction"];
  List<String> get categories => _categories;

  List<Book> _fictionalBooks;
  List<Book> _educationalBooks;
  List<Book> _nonFictionBooks;

  List<Book> get fictionalBooks => _fictionalBooks;
  List<Book> get educationalBooks => _educationalBooks;
  List<Book> get nonFictionBooks => _nonFictionBooks;

  //
  @override
  void onInit() {
    getFictionBooks();
    getEducationalBooks();
    getNonFictionalBooks();
    super.onInit();
  }

  List<Book> getBooksBasedOnCategory(String category) {
    // ignore: unused_local_variable
    List<Book> booksBasedOnCategory;
    return booksBasedOnCategory = List.from(_apiController.booksList.where((book) => book.category == category));
  }

  void getFictionBooks() {
    _fictionalBooks = List.from(_apiController.booksList.where((book) => book.category == _categories[0]));
    // _fictionalBooks = _apiController.booksList.isEmpty ? null : List.from(_apiController.booksList.where((book) => book.category == _categories[0]));
    update();
  }

  void getEducationalBooks() {
    _educationalBooks = List.from(_apiController.booksList.where((book) => book.category == _categories[1]));
    // _educationalBooks = _apiController.booksList.isEmpty ? null : List.from(_apiController.booksList.where((book) => book.category == _categories[1]));
    update();
  }

  void getNonFictionalBooks() {
    _nonFictionBooks = List.from(_apiController.booksList.where((book) => book.category == _categories[2]));
    // _nonFictionBooks = _apiController.booksList.isEmpty ? null : List.from(_apiController.booksList.where((book) => book.category == _categories[2]));
    update();
  }
}
