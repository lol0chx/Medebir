import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:get/get.dart';
import 'package:medebir_with_getx/controllers/api_controller.dart';
import 'package:medebir_with_getx/controllers/auth_controller.dart';
import 'package:medebir_with_getx/controllers/cart_controller.dart';
import 'package:medebir_with_getx/controllers/category_controller.dart';
import 'package:medebir_with_getx/controllers/favorites_controller.dart';
import 'package:medebir_with_getx/views/app/home/book_detail.dart';
import 'package:medebir_with_getx/views/app/home/check_out.dart';
import 'package:medebir_with_getx/views/app/home/more_books_screen.dart';
import 'package:medebir_with_getx/views/app/home/search_screen.dart';
import 'package:medebir_with_getx/views/app/home/settings.dart';
import 'package:medebir_with_getx/views/components/title_row.dart';
import '../../components/book_functions.dart';

//

class HomeScreen extends StatefulWidget {
  final int selectedIndex;
  HomeScreen({this.selectedIndex});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiController apiController = Get.find<ApiController>();
  final AuthController authController = Get.find<AuthController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  TabController _tabController;
  double yTransValue = 0;
  ScrollController _scrollController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.selectedIndex != null) {
      setState(() {
        _currentTabIndex = widget.selectedIndex;
      });
    }
    _tabController = TabController(length: 5, vsync: this);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final devHeight = MediaQuery.of(context).size.height;
    final devWidth = MediaQuery.of(context).size.width;
    EdgeInsets _mainPadding = const EdgeInsets.symmetric(horizontal: 20.0);
    return GetX<ApiController>(
      builder: (controller) => KeyboardSizeProvider(
        smallSize: 500,
        child: DefaultTabController(
          initialIndex: _currentTabIndex,
          length: 5,
          child: Scaffold(
              key: _scaffoldKey,
              body: apiController.booksList.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : SafeArea(
                      child: Consumer<ScreenHeight>(
                        builder: (context, value, child) => buildBodyStack(devHeight: devHeight, devWidth: devWidth, mainPadding: _mainPadding, value: value),
                      ),
                    )),
        ),
      ),
    );
  }

  //
  //
  Widget buildBodyStack({double devHeight, double devWidth, EdgeInsets mainPadding, ScreenHeight value}) {
    switch (_currentTabIndex) {
      case 0:
        return Stack(
          children: [
            //TODO: list of books part
            Container(
              child: NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
                  if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
                    setState(() {
                      yTransValue = 0;
                    });
                  } else if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
                    setState(() {
                      yTransValue = 100;
                    });
                  }
                  return true;
                },
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overScroll) {
                    overScroll.disallowGlow();
                    return true;
                  },
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      //homeScreen items
                      SizedBox(height: devHeight * 0.11),
                      BuildTitleRow(onPressed: () {}, mainPadding: mainPadding, title: "New Releases"),
                      apiController.booksList.isEmpty ? Center(child: CircularProgressIndicator()) : BookFunction.buildNewReleases(devHeight, devWidth, apiController),
                      SizedBox(height: devHeight * 0.02),
                      BuildTitleRow(onPressed: () {}, mainPadding: mainPadding, title: "Top Rated"),
                      SizedBox(height: devHeight * 0.02),
                      apiController.booksList.isEmpty ? Center(child: CircularProgressIndicator()) : BookFunction.buildTopRated(devHeight, devWidth, apiController),
                      SizedBox(height: devHeight * 0.02),
                      BuildTitleRow(onPressed: () {}, mainPadding: mainPadding, title: "Top Priced"),
                      SizedBox(height: devHeight * 0.02),
                      apiController.booksList.isEmpty ? Center(child: CircularProgressIndicator()) : BookFunction.buildTopPriced(devHeight, devWidth, apiController),
                    ],
                  ),
                ),
              ),
            ),
            //end
            //
            //search and profile icon row
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                transform: Matrix4.translationValues(0, -yTransValue, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  height: devHeight * 0.1,
                  padding: mainPadding,
                  child: Container(
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("BStore", style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600)),
                        Spacer(),
                        IconButton(
                          onPressed: () {
                            // showSearch(context: context, delegate: BookSearch());
                            Get.to(() => SearchScreen(), transition: Transition.cupertino);
                          },
                          icon: Icon(Icons.search, size: 32.0),
                        ),
                        SizedBox(width: devWidth * 0.03),
                        GetX<AuthController>(
                          builder: (authController) => GestureDetector(
                            onTap: () => Get.to(() => Settings(), transition: Transition.cupertino),
                            child: Container(
                              height: 40.0,
                              width: 40.0,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green.withOpacity(0.5), width: 1.0),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: authController.currentUser == null ? AssetImage("assets/logo.png") : NetworkImage(authController.currentUser.profileImgUrl),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // end
            //
            //bottom navigation bar
            value.isOpen ? Container() : buildBottomNavBar(devHeight),
          ],
        );
        break;
      case 1:
        return Stack(
          children: [
            //category tab
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text("Categories", style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(height: devHeight * 0.04),
                  Expanded(
                    child: ListView.builder(
                      itemCount: categoryController.categories.length,
                      itemBuilder: (context, index) {
                        return MaterialButton(
                          onPressed: () => Get.to(() => MoreBooks(selectedCategory: categoryController.categories[index]), transition: Transition.cupertino),
                          // color: Colors.teal,
                          height: 60.0,
                          minWidth: double.infinity,
                          child: Row(
                            children: [
                              Icon(Icons.book),
                              SizedBox(width: devWidth * 0.02),
                              Text(categoryController.categories[index], style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600)),
                              Spacer(),
                              Icon(Icons.arrow_forward_ios_rounded),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            //end

            //
            SizedBox(height: devHeight * 0.02),
            //bottom navigation bar
            value.isOpen ? Container() : buildBottomNavBar(devHeight),
          ],
        );
        break;
      case 2:
        return Stack(
          children: [
            SizedBox(height: devHeight * 0.02),
            //Cart tab
            GetBuilder<CartController>(
              builder: (_cartController) => _cartController.cartList.isEmpty
                  ? Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_shopping_cart, size: 40.0, color: Colors.purple),
                          SizedBox(height: devHeight * 0.02),
                          Text('Nothing in cart'),
                        ],
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          // gradient: LinearGradient(colors: [Color(0x118fd6e1), Colors.purple.withOpacity(0.4)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                          ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: devHeight * 0.05),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text("My Cart", style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
                          ),
                          // SizedBox(height: devHeight * 0.02),
                          Expanded(
                            child: Container(
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                    key: ObjectKey(_cartController.cartList[index].sId),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      if (direction == DismissDirection.endToStart) {
                                        _cartController.removeCartItem(_cartController.cartList[index]);
                                      }
                                    },
                                    child: GestureDetector(
                                      onTap: () => Get.to(() => BookDetail(selectedBook: _cartController.cartList[index], listFrom: "cart"), transition: Transition.fadeIn),
                                      child: Container(
                                        height: devHeight * 0.2,
                                        margin: index == 0
                                            ? const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0)
                                            : EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0, bottom: 5.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20.0),
                                          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), offset: Offset(2, 4), blurRadius: 10.0)],
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 120.0,
                                              width: 120.0,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(image: NetworkImage(_cartController.cartList[index].posterImage)),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                // color: Colors.red,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(_cartController.cartList[index].title, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
                                                    SizedBox(height: devHeight * 0.02),
                                                    Text(
                                                      "By ${_cartController.cartList[index].author}",
                                                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.grey),
                                                    ),
                                                    SizedBox(height: devHeight * 0.03),
                                                    Text(
                                                      _cartController.cartList[index].price,
                                                      style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: _cartController.cartList.length,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MaterialButton(
                                  onPressed: () {
                                    Get.to(() => CheckOut());
                                  },
                                  height: 50.0,
                                  minWidth: 200,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                                  color: Colors.purple,
                                  child: Text('Check out', style: TextStyle(color: Colors.white, fontSize: 18.0)),
                                ),
                                // SizedBox(width: devWidth * 0.15),
                                Text("\$${_cartController.total.toString()}", style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                          SizedBox(height: devHeight * 0.13),
                        ],
                      ),
                    ),
            ),
            //end
            //

            SizedBox(height: devHeight * 0.02),
            //bottom navigation bar
            value.isOpen ? Container() : buildBottomNavBar(devHeight),
          ],
        );
        break;
      case 3:
        return Stack(
          children: [
            // //search tab
          ],
        );
        break;
      case 4:
        return Stack(
          children: [
            //wishlist tab
            GetBuilder<FavoritesController>(
              builder: (controller) => Container(
                width: double.infinity,
                child: controller.favoriteBooksList.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite, size: 40.0, color: Colors.purple),
                          SizedBox(height: devHeight * 0.02),
                          Text("No book In Wishlist"),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            child: Text("WishList", style: TextStyle(fontSize: 24.0, color: Colors.purple, fontWeight: FontWeight.w600)),
                          ),
                          Expanded(
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: controller.favoriteBooksList.length,
                              itemBuilder: (context, index) {
                                return Dismissible(
                                  key: ObjectKey(controller.favoriteBooksList[index].sId),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    if (direction == DismissDirection.endToStart) {
                                      controller.removeFromFavorites(controller.favoriteBooksList[index]);
                                    }
                                  },
                                  child: GestureDetector(
                                    onTap: () => Get.to(() => BookDetail(selectedBook: controller.favoriteBooksList[index], listFrom: ""), transition: Transition.cupertino),
                                    child: Container(
                                      height: devHeight * 0.2,
                                      margin:
                                          index == 0 ? const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0) : EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0, bottom: 5.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20.0),
                                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), offset: Offset(2, 4), blurRadius: 10.0)],
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 120.0,
                                            width: 120.0,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(image: NetworkImage(controller.favoriteBooksList[index].posterImage)),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              // color: Colors.red,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(controller.favoriteBooksList[index].title, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
                                                  SizedBox(height: devHeight * 0.02),
                                                  Text(
                                                    "By ${controller.favoriteBooksList[index].author}",
                                                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.grey),
                                                  ),
                                                  SizedBox(height: devHeight * 0.03),
                                                  Text(
                                                    controller.favoriteBooksList[index].price,
                                                    style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            //end
            //
            SizedBox(height: devHeight * 0.02),
            //bottom navigation bar
            value.isOpen ? Container() : buildBottomNavBar(devHeight),
          ],
        );
        break;
      default:
        {
          print.printError(info: "error on bottom nav bar");
          AuthController.showSnackBar(title: "Error with bottom Nav bar", message: "Please choose correct opetions.", bgColor: Colors.red, txtColor: Colors.white);
        }
    }
    return null;
  }

  Widget buildBottomNavBar(double devHeight) {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        transform: Matrix4.translationValues(0, yTransValue, 0),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            child: Container(
              height: devHeight * 0.08,
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() => _currentTabIndex = 0);
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: Icon(Icons.home_rounded, size: 24.0, color: _currentTabIndex == 0 ? Colors.black : Colors.white)),
                  IconButton(
                      onPressed: () {
                        setState(() => _currentTabIndex = 1);
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: Icon(Icons.category, size: 24.0, color: _currentTabIndex == 1 ? Colors.black : Colors.white)),
                  IconButton(
                    onPressed: () {
                      setState(() => _currentTabIndex = 2);
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Stack(
                      children: [
                        Icon(Icons.shopping_cart, size: 24.0, color: _currentTabIndex == 2 ? Colors.black : Colors.white),
                        Get.find<CartController>().cartList.length == 0
                            ? SizedBox.shrink()
                            : Positioned(
                                right: -3,
                                top: -7,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.purple),
                                  child: Center(
                                      child: Text(Get.find<CartController>().cartList.length.toString(),
                                          style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold))),
                                ),
                              ),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Get.to(() => SearchScreen(), transition: Transition.cupertino);
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: Icon(Icons.search, size: 24.0, color: _currentTabIndex == 3 ? Colors.black : Colors.white)),
                  IconButton(
                      onPressed: () {
                        setState(() => _currentTabIndex = 4);
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: Icon(Icons.favorite, size: 24.0, color: _currentTabIndex == 4 ? Colors.black : Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
