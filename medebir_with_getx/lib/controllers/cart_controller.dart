import 'package:get/get.dart';
import 'package:medebir_with_getx/models/book.dart';

class CartController extends GetxController {
  List<Book> _cartList = [];

  List<Book> get cartList => _cartList;
  double _totalPrice = 0;
  double get total => _totalPrice;

  void addToCart(Book selectedBook) {
    if (!_cartList.contains(selectedBook)) {
      _cartList.add(selectedBook);
      _totalPrice += double.parse("${selectedBook.price.substring(1)}");
      print("${selectedBook.price.substring(1, 3)}");
    }
    update();
  }

  void clearCartList() {
    cartList.clear();
    _totalPrice = 0;
    update();
  }

  void removeCartItem(Book bookToBeRemoved) {
    _cartList.remove(bookToBeRemoved);
    double removedItemPrice = double.parse("${bookToBeRemoved.price.substring(1)}");
    _totalPrice -= removedItemPrice;
    print(removedItemPrice);
    update();
  }
}
