import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medebir_with_getx/controllers/category_controller.dart';
import 'package:medebir_with_getx/models/book.dart';
import 'book_detail.dart';

class MoreBooks extends StatefulWidget {
  final String selectedCategory;
  MoreBooks({this.selectedCategory});

  @override
  _MoreBooksState createState() => _MoreBooksState();
}

class _MoreBooksState extends State<MoreBooks> {
  CategoryController categoryController = Get.find<CategoryController>();

  List<Book> booksList;

  @override
  void initState() {
    setState(() {
      booksList = categoryController.getBooksBasedOnCategory(widget.selectedCategory);
    });
    print(booksList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: booksList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.category, color: Colors.purple, size: 40.0),
                    SizedBox(height: size.height * 0.02),
                    Text("Nothing in this category.", style: TextStyle(color: Colors.purple, fontSize: 16.0)),
                  ],
                ),
              )
            : Container(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: booksList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Get.to(() => BookDetail(selectedBook: booksList[index], listFrom: ""), transition: Transition.cupertino),
                      child: Container(
                        height: size.height * 0.2,
                        margin: index == 0 ? const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0) : EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0, bottom: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), offset: Offset(2, 4), blurRadius: 10.0)],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: size.width * 0.02),
                            CachedNetworkImage(
                              imageUrl: booksList[index].posterImage,
                              imageBuilder: (context, imageProvider) => ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  height: size.height * 0.16,
                                  width: size.width * 0.25,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                height: size.height * 0.16,
                                width: size.width * 0.25,
                                decoration: BoxDecoration(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: size.width * 0.04),
                            Expanded(
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(booksList[index].title, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
                                    SizedBox(height: size.height * 0.02),
                                    Text(
                                      "By ${booksList[index].author}",
                                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.grey),
                                    ),
                                    SizedBox(height: size.height * 0.03),
                                    Text(
                                      booksList[index].price,
                                      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
