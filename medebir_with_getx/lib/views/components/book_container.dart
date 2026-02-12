import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:medebir_with_getx/controllers/api_controller.dart';
import 'package:medebir_with_getx/models/book.dart';

class BuildBookContainer extends StatelessWidget {
  const BuildBookContainer({
    Key key,
    @required this.apiController,
    @required this.devHeight,
    @required this.devWidth,
    @required this.index,
    @required this.booksList,
    @required this.listFrom,
  }) : super(key: key);

  final ApiController apiController;
  final double devHeight;
  final double devWidth;
  final int index;
  final List<Book> booksList;
  final String listFrom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: booksList[index].sId + listFrom,
            child: CachedNetworkImage(
              imageUrl: booksList[index].posterImage,
              imageBuilder: (context, imageProvider) => Container(
                height: devHeight * 0.2,
                width: devWidth * 0.25,
                decoration: BoxDecoration(
                  image: apiController.booksList.isEmpty ? null : DecorationImage(image: imageProvider, fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(2, 3), blurRadius: 5.0)],
                ),
              ),
              placeholder: (context, url) => Container(
                height: devHeight * 0.2,
                width: devWidth * 0.25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(2, 3), blurRadius: 5.0)],
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(height: devHeight * 0.005),
          Container(
            width: devWidth * 0.25,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  apiController.booksList.isEmpty ? "" : booksList[index].title,
                  style: TextStyle(color: Colors.grey),
                  overflow: booksList.isEmpty
                      ? null
                      : booksList[index].title.length > 7
                          ? TextOverflow.ellipsis
                          : null,
                ),
                Text(booksList[index].price, style: TextStyle(color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
