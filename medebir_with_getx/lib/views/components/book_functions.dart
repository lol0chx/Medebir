import 'package:flutter/material.dart';
import 'package:medebir_with_getx/controllers/api_controller.dart';
import 'package:medebir_with_getx/models/book.dart';
import 'package:medebir_with_getx/views/app/home/book_detail.dart';
import 'package:get/get.dart';
import 'package:medebir_with_getx/views/components/book_container.dart';

class BookFunction {
  static int duration = 400;
  static Widget buildNewReleases(double devHeight, double devWidth, ApiController apiController) {
    List<Book> newReleasesBooks = List.from(apiController.booksList);
    newReleasesBooks.sort((a, b) => DateTime.parse(b.postDate).compareTo(DateTime.parse(a.postDate)));

    return Container(
      height: devHeight * 0.27,
      padding: const EdgeInsets.only(top: 10.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () =>
                Get.to(() => BookDetail(selectedBook: newReleasesBooks[index], listFrom: "NewReleases"), transition: Transition.fadeIn, duration: Duration(milliseconds: duration)),
            child: BuildBookContainer(apiController: apiController, devHeight: devHeight, devWidth: devWidth, index: index, booksList: newReleasesBooks, listFrom: "NewReleases"),
          );
        },
        itemCount: 10,
      ),
    );
  }

  static Widget buildTopRated(double devHeight, double devWidth, ApiController apiController) {
    List<Book> topRatedBooks = List.from(apiController.booksList);
    topRatedBooks.sort((a, b) => int.parse(b.rating).compareTo(int.parse(a.rating)));

    return Container(
      height: devHeight * 0.27,
      padding: const EdgeInsets.only(top: 10.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () =>
                Get.to(() => BookDetail(selectedBook: topRatedBooks[index], listFrom: "TopRated"), transition: Transition.fadeIn, duration: Duration(milliseconds: duration)),
            child: BuildBookContainer(apiController: apiController, devHeight: devHeight, devWidth: devWidth, index: index, booksList: topRatedBooks, listFrom: "TopRated"),
          );
        },
        itemCount: apiController.booksList.length,
      ),
    );
  }

  static Widget buildTopPriced(double devHeight, double devWidth, ApiController apiController) {
    List<Book> topRatedBooks = List.from(apiController.booksList);
    topRatedBooks.sort((a, b) => int.parse(b.price.substring(1)).compareTo(int.parse(a.price.substring(1))));

    return Container(
      height: devHeight * 0.27,
      padding: const EdgeInsets.only(top: 10.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () =>
                Get.to(() => BookDetail(selectedBook: topRatedBooks[index], listFrom: "TopPriced"), transition: Transition.fadeIn, duration: Duration(milliseconds: duration)),
            child: BuildBookContainer(apiController: apiController, devHeight: devHeight, devWidth: devWidth, index: index, booksList: topRatedBooks, listFrom: "TopPriced"),
          );
        },
        itemCount: apiController.booksList.length,
      ),
    );
  }
}
