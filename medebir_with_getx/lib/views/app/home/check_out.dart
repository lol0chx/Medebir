import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medebir_with_getx/controllers/auth_controller.dart';
import 'package:medebir_with_getx/controllers/cart_controller.dart';
import 'package:medebir_with_getx/controllers/checkout_controller.dart';
import 'package:medebir_with_getx/helper/phone_number_helper.dart';

class CheckOut extends StatefulWidget {
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final CartController _cartController = Get.find<CartController>();
  final CheckOutController _checkOutController = Get.find<CheckOutController>();

  // ignore: non_constant_identifier_names
  String city, country, staddress, region, poi_addr_street, poi_name;
  TextStyle _addressStyle = TextStyle(fontSize: 16.0, letterSpacing: 1.2);
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    getAddressData();
    super.initState();
  }

  void getAddressData() async {
    Map<String, String> _address = await _checkOutController.getAddress();
    setState(() {
      city = _address['city'];
      country = _address['country'];
      staddress = _address['staddress'];
      region = _address['region'];
      poi_addr_street = _address['poi_addr_street'];
      poi_name = _address['poi_name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.04),
                Text("Your Address", style: TextStyle(color: Colors.black, fontSize: 28.0)),
                SizedBox(height: size.height * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Cart item", style: TextStyle(color: Colors.purple, fontSize: 24.0)),
                    Text(_cartController.cartList.length.toString(), style: TextStyle(color: Colors.deepPurple, fontSize: 24.0)),
                  ],
                ),
                SizedBox(height: size.height * 0.04),
                Text("Deliver to my current location: ", style: TextStyle(color: Colors.black, fontSize: 18.0)),
                SizedBox(height: size.height * 0.02),
                Container(
                  height: size.height * 0.2,
                  child: city == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: size.width * 0.04),
                            Text("Finding your current location"),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            country == null ? SizedBox.shrink() : Text(country, style: _addressStyle),
                            region == null ? SizedBox.shrink() : Text(region, style: _addressStyle),
                            city == null ? SizedBox.shrink() : Text(city, style: _addressStyle),
                            poi_addr_street == null ? SizedBox.shrink() : Text(poi_addr_street, style: _addressStyle),
                            staddress == null ? SizedBox.shrink() : Text(staddress, style: _addressStyle),
                          ],
                        ),
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(hintText: "Example: 0912345678"),
                ),
                SizedBox(height: size.height * 0.08),
                MaterialButton(
                  onPressed: () {
                    if (_phoneController.text == null || _phoneController.text == "" || _phoneController.text.length <= 2) {
                      AuthController.showSnackBar(
                          title: "Phone number",
                          message: "Please fill your phone number correctly",
                          txtColor: Colors.white,
                          bgColor: Colors.red,
                          durationSecond: 2,
                          position: SnackPosition.TOP);
                    } else {
                      String formatedPhone = checkPhoneNumber(_phoneController.text);
                      if (formatedPhone == "error") {
                        AuthController.showSnackBar(
                            title: "Incorrect phone number",
                            message: "Please fill your phone number correctly",
                            txtColor: Colors.white,
                            bgColor: Colors.red,
                            durationSecond: 2,
                            position: SnackPosition.TOP);
                      } else {
                        _checkOutController.checkOut(_phoneController.text);
                      }
                    }
                  },
                  minWidth: double.infinity,
                  height: 50.0,
                  color: Colors.purple,
                  child: Text('Buy now', style: TextStyle(color: Colors.white, fontSize: 18.0)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
                SizedBox(height: size.height * 0.08),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
