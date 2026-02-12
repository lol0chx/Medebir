import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medebir_with_getx/controllers/api_controller.dart';
import 'package:medebir_with_getx/models/book.dart';
import 'book_detail.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Book> _booksList = Get.find<ApiController>().booksList;

  @override
  Widget build(BuildContext context) {
    final devHeight = MediaQuery.of(context).size.height;
    final devWIdth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: devHeight * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.search, color: Colors.black),
                    SizedBox(width: devWIdth * 0.02),
                    Expanded(
                      child: TextField(
                        onChanged: searchBook,
                        autofocus: true,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black, fontSize: 24.0),
                        decoration: InputDecoration(
                          hintText: "Search books...",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.white)),
                          filled: true,
                          fillColor: Color(0xfffdfaf6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: devHeight * 0.04),

              //
              Expanded(
                child: ListView.builder(
                  itemCount: _booksList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => Get.to(() => BookDetail(selectedBook: _booksList[index], listFrom: "search"), transition: Transition.cupertino),
                      leading: Image(
                        image: NetworkImage(_booksList[index].posterImage),
                      ),
                      title: Text(_booksList[index].title),
                      subtitle: Text("By ${_booksList[index].author}"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void searchBook(String query) {
    print(query);
    final List<Book> books = Get.find<ApiController>().booksList.where((book) {
      //
      final titleLower = book.title.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower);
    }).toList();
    setState(() {
      _booksList = books;
    });
  }
}
