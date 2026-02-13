import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:medebir_with_getx/controllers/auth_controller.dart';
import 'package:medebir_with_getx/controllers/cart_controller.dart';
import 'package:medebir_with_getx/views/app/home/loading.dart';
import 'package:medebir_with_getx/views/app/home/home.dart';
import 'auth_controller.dart';

class CheckOutController extends GetxController {
  var address;
  //
  Future<LocationData> getLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    _locationData = await location.getLocation();
    return _locationData;
  }

  Future<Map<String, String>> getAddress() async {
    LocationData _locationData = await getLocation();
    Uri uri = Uri.parse("https://geocode.xyz/${_locationData.latitude.toString().trim()},${_locationData.longitude.toString().trim()}?json=1&auth=150347897744541e15937001x42367");
    var response = await http.get(uri);
    var jsonDecodedData = jsonDecode(response.body);
    address = {
      "city": jsonDecodedData['city'].toString(),
      "staddress": jsonDecodedData['staddress'].toString(),
      "region": jsonDecodedData['region'].toString(),
      "country": jsonDecodedData['country'].toString(),
      "poi_addr_street": jsonDecodedData['poi']['addr_street'].toString(),
      "poi_name": jsonDecodedData['poi']['name'].toString()
    };
    return address;
  }

  static void showSnackBar({String title, String message, Color bgColor, Color txtColor, SnackPosition position = SnackPosition.BOTTOM, int durationSecond = 5}) {
    return Get.snackbar(
      title,
      message,
      duration: Duration(seconds: durationSecond),
      snackPosition: position,
      backgroundColor: bgColor,
      colorText: txtColor,
      margin:
          position == SnackPosition.BOTTOM ? const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0) : const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0, top: 20.0),
      messageText: Text(message, style: TextStyle(fontWeight: FontWeight.bold, color: txtColor)),
      titleText: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: txtColor, fontSize: 20.0)),
    );
  }

  void checkOut(String phoneNumber) async {
    Get.to(() => Loading());
    final CartController _cartController = Get.find<CartController>();
    final AuthController _authController = Get.find<AuthController>();

    Uri adminUrl = Uri.parse("http://10.0.2.2:4000/admin");
    //
    String name = _authController.currentUser.name;
    var purchasedBooks = [];
    for (var i = 0; i < _cartController.cartList.length; i++) {
      purchasedBooks.add(_cartController.cartList[i].toJson());
    }
    try {
      await http.post(
        adminUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': name.capitalize,
          'phoneNumber': phoneNumber,
          "address": address,
          'purchasedBooks': purchasedBooks,
          "purchasedDate": DateTime.now().toString().trim(),
        }),
      );
      Get.snackbar(
        "Book Successfully Purchased",
        "${_cartController.cartList.length} Books are pending to be delivered to ${name.capitalize}",
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );
      // _cartController.cartList.clear();
      _cartController.clearCartList();
      Get.offAll(() => HomeScreen());
      showSnackBar(
        bgColor: Colors.green,
        durationSecond: 15,
        message: "Books purchased! \nYou will recieve a call with in 2 minute. \n If you don't get a call. contact: 0912345678",
        title: "Book Purchased",
        txtColor: Colors.white,
        position: SnackPosition.TOP,
      );
    } catch (e) {
      Get.back();
      print(e);
    }
  }
}
