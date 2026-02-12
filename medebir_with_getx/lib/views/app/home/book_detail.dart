import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medebir_with_getx/controllers/api_controller.dart';
import 'package:medebir_with_getx/controllers/cart_controller.dart';
import 'package:medebir_with_getx/controllers/favorites_controller.dart';
import 'package:medebir_with_getx/models/book.dart';

class BookDetail extends StatefulWidget {
  final Book selectedBook;
  final String listFrom;
  BookDetail({@required this.selectedBook, @required this.listFrom});

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> with TickerProviderStateMixin {
  final ApiController apiController = Get.find<ApiController>();
  final FavoritesController favoritesController = Get.find<FavoritesController>();

  @override
  Widget build(BuildContext context) {
    final devHeight = MediaQuery.of(context).size.height;
    final devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(height: devHeight * 0.04),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: widget.selectedBook.sId + widget.listFrom,
                          child: CachedNetworkImage(
                            imageUrl: widget.selectedBook.posterImage,
                            imageBuilder: (context, imageProvider) => Container(
                              height: devHeight * 0.3,
                              width: devWidth * 0.4,
                              decoration: BoxDecoration(
                                image: apiController.booksList.isEmpty ? null : DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(2, 3), blurRadius: 5.0)],
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              height: devHeight * 0.3,
                              width: devWidth * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(2, 3), blurRadius: 5.0)],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            // errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                        // widget.selectedBook.posterImage
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 10.0),
                                child: Text(
                                  widget.selectedBook.title.toString().trim(),
                                  style: TextStyle(fontSize: 26.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                                child: Text(widget.selectedBook.author.toString().trim(), style: TextStyle(fontSize: 20.0, color: Theme.of(context).primaryColor)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                                child: RatingStars(
                                  value: double.parse(widget.selectedBook.rating),
                                  onValueChanged: (v) {},
                                  starBuilder: (index, color) => Icon(Icons.star, color: color),
                                  starCount: 5,
                                  starSize: 20,
                                  maxValue: 5,
                                  starSpacing: 2,
                                  animationDuration: Duration(milliseconds: 1000),
                                  starOffColor: const Color(0xffe7e8ea),
                                  starColor: Colors.yellow,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                                child: Text(widget.selectedBook.price.toString().trim(), style: TextStyle(fontSize: 26.0, color: Colors.orange)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: devHeight * 0.04),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Details", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Colors.black)),
                        SizedBox(height: devHeight * 0.02),
                        Row(
                          children: [
                            Text("Author", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey)),
                            SizedBox(width: devWidth * 0.3),
                            Expanded(
                                child: Text(
                              widget.selectedBook.author.toString().trim(),
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Theme.of(context).primaryColor),
                            )),
                          ],
                        ),
                        SizedBox(height: devHeight * 0.01),
                        Row(
                          children: [
                            Text("Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey)),
                            SizedBox(width: devWidth * 0.25),
                            Expanded(
                                child: Text(widget.selectedBook.category.toString().trim(), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.black))),
                          ],
                        ),
                        SizedBox(height: devHeight * 0.01),
                        Row(
                          children: [
                            Text("Publication Date", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey)),
                            SizedBox(width: devWidth * 0.1),
                            Expanded(
                                child: Text(DateFormat.yMMMd().format(DateTime.parse(widget.selectedBook.postDate.toString().trim())),
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black))),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: devHeight * 0.04),
                    Text("Description", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Colors.black)),
                    SizedBox(height: devHeight * 0.02),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        "${widget.selectedBook.description.toString().trim()}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black, height: 1.3),
                      ),
                    ),
                    SizedBox(height: devHeight * 0.15),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: InkWell(
                onTap: () {
                  Get.find<CartController>().cartList.contains(widget.selectedBook)
                      ? Get.find<CartController>().removeCartItem(widget.selectedBook)
                      : Get.find<CartController>().addToCart(widget.selectedBook);
                  Get.back();
                },
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  height: devHeight * 0.07,
                  child: Center(
                    child: Text(
                      Get.find<CartController>().cartList.contains(widget.selectedBook) ? "Remove from cart" : 'Add to Cart',
                      style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Get.find<CartController>().cartList.contains(widget.selectedBook) ? Colors.red[400] : Color(0xffBF1363),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(2, 9), blurRadius: 10.0)],
                  ),
                ),
              ),
            ),
            SizedBox(width: devWidth * 0.04),
            GetBuilder<FavoritesController>(
              builder: (controller) => Expanded(
                child: InkWell(
                  onTap: () async {
                    controller.addToFavorites(widget.selectedBook);
                  },
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    height: devHeight * 0.07,
                    child: Center(
                      child: Icon(
                        Icons.favorite,
                        color: controller.favoriteBooksList.contains(widget.selectedBook) ? Colors.yellowAccent : Colors.grey,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: controller.favoriteBooksList.contains(widget.selectedBook) ? Colors.pink : Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(2, 9), blurRadius: 10.0)],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
