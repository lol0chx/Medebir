import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medebir_with_getx/controllers/auth_controller.dart';
import 'about_us.dart';
import 'package:medebir_with_getx/views/app/home/home.dart';

class Settings extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    final devHeight = MediaQuery.of(context).size.height;
    final devWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                child: Row(children: [
                  IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back_ios_new)),
                  SizedBox(width: devWidth * 0.02),
                  Text('Profile', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
                ]),
              ),
              SizedBox(height: devHeight * 0.1),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue.shade100, width: 1.0),
                ),
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  height: 120.0,
                  width: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: NetworkImage(_authController.currentUser.profileImgUrl), fit: BoxFit.contain),
                  ),
                ),
              ),
              SizedBox(height: devHeight * 0.02),
              Container(child: Text(_authController.currentUser.name, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600))),
              SizedBox(height: devHeight * 0.05),
              Spacer(),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffd8e3e7).withOpacity(0.3),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: devHeight * 0.03),
                    buildButtons(
                        onpressed: () => Get.offAll(() => HomeScreen(selectedIndex: 4), transition: Transition.fade),
                        leadIcon: Icon(Icons.favorite, size: 21.0),
                        devWidth: devWidth,
                        text: "Wishlist"),
                    buildButtons(
                        onpressed: () => Get.to(() => AboutUs(), transition: Transition.fade),
                        leadingIcon: FaIcon(FontAwesomeIcons.at, size: 21.0),
                        devWidth: devWidth,
                        text: "About us"),
                    buildButtons(
                      onpressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Log out'),
                            content: Text("Are you sure?"),
                            elevation: 20.0,
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => _authController.signOut(),
                                child: Text('Yes'),
                              ),
                            ],
                          ),
                        );
                      },
                      leadingIcon: FaIcon(FontAwesomeIcons.signOutAlt, size: 21.0),
                      devWidth: devWidth,
                      text: "Log out",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtons({Function onpressed, FaIcon leadingIcon, Icon leadIcon, String text, double devWidth}) {
    return MaterialButton(
      splashColor: Color(0xfffff5fd),
      height: 60.0,
      onPressed: onpressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              leadIcon == null ? leadingIcon : leadIcon,
              SizedBox(width: devWidth * 0.04),
              Text(text, style: TextStyle(fontSize: 20.0)),
            ],
          ),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
