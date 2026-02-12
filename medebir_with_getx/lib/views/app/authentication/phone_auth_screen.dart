import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medebir_with_getx/controllers/auth_controller.dart';

class PhoneAuth extends StatelessWidget {
  final phoneNumber;
  PhoneAuth({@required this.phoneNumber});

  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final devHeight = MediaQuery.of(context).size.height;
    // final devWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: devHeight * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                  child: Text(
                    'Welcome Back,',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Enter your password',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 32),
                  ),
                ),
                SizedBox(height: devHeight * 0.05),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextFormField(
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(height: devHeight * 0.04),
                        MaterialButton(
                          onPressed: () async {
                            _authController.signInWithPhoneNumberAndPassword(phoneNumber, _passwordController.text);
                          },
                          height: 50.0,
                          minWidth: 200.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                          color: Theme.of(context).primaryColor,
                          child: Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 16.0)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
