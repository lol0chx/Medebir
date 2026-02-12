import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:medebir_with_getx/controllers/api_controller.dart';
import 'package:medebir_with_getx/controllers/auth_controller.dart';
import 'package:medebir_with_getx/controllers/cart_controller.dart';
import 'package:medebir_with_getx/controllers/category_controller.dart';
import 'package:medebir_with_getx/controllers/checkout_controller.dart';
import 'package:medebir_with_getx/controllers/favorites_controller.dart';
import 'package:medebir_with_getx/controllers/userSetting_controller.dart';
import 'package:medebir_with_getx/views/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));
  Get.put<AuthController>(AuthController());
  Get.put<UserSettingController>(UserSettingController());
  Get.put<ApiController>(ApiController());
  Get.put<CartController>(CartController());
  Get.put<CategoryController>(CategoryController());
  Get.put<FavoritesController>(FavoritesController());
  Get.put<CheckOutController>(CheckOutController());

  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BStore',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Root(),
    );
  }
}
