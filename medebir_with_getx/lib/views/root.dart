import 'package:medebir_with_getx/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './app//authentication/_choice.dart';
import 'package:medebir_with_getx/views/app/home/home.dart';

class Root extends GetWidget<AuthController> {
  final AuthController authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() => (authController.user != null) ? HomeScreen() : LoginChoiceScreen());
  }
}
