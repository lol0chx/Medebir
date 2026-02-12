import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:medebir_with_getx/controllers/auth_controller.dart';
import 'package:medebir_with_getx/helper/phone_number_helper.dart';

class SignInPhoneScreen extends StatefulWidget {
  @override
  _SignInPhoneScreenState createState() => _SignInPhoneScreenState();
}

class _SignInPhoneScreenState extends State<SignInPhoneScreen> {
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthController _authController = Get.find<AuthController>();

  final _picker = ImagePicker();
  PickedFile _pickedFile;
  File _proPicImgFile;

  DateTime _dateOfBirth;

  void setPickedFile() async {
    // if (_pickedFile != null) {
    _pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {});
    _proPicImgFile = File(_pickedFile.path);
    setState(() {});
    // }
  }

  @override
  Widget build(BuildContext context) {
    final devHeight = MediaQuery.of(context).size.height;
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
                    'Welcome,',
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
                    'Sign in',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 32),
                  ),
                ),
                SizedBox(height: devHeight * 0.05),
                Center(
                  child: GestureDetector(
                    onTap: () => setPickedFile(),
                    child: Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                        image: _proPicImgFile != null ? DecorationImage(image: FileImage(_proPicImgFile), fit: BoxFit.fill) : null,
                      ),
                      // color: Colors.red,
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0.0,
                            right: 10.0,
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: Icon(Icons.add, color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                          controller: _nameController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                            labelText: "Name",
                            labelStyle: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14.0),
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
                        SizedBox(height: devHeight * 0.02),
                        MaterialButton(
                          minWidth: double.infinity,
                          height: 50.0,
                          // color: Colors.orange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.grey, width: 1.0)),
                          onPressed: () async {
                            final DateTime _newDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(DateTime.now().year - 100),
                              lastDate: DateTime.now(),
                            );
                            if (_newDate != null) {
                              setState(() {
                                _dateOfBirth = _newDate;
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Text(_dateOfBirth == null ? 'Date Of Birth' : DateFormat('yMMMEd').format(_dateOfBirth),
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14.0)),
                            ],
                          ),
                        ),
                        SizedBox(height: devHeight * 0.02),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _phoneController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                            hintText: "Example: 0912345678",
                            hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14.0, color: Colors.grey),
                            labelText: "Phone",
                            labelStyle: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14.0),
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
                          onPressed: () {
                            //TODO: implement the sign in button

                            if (_pickedFile == null || _nameController.text == null || _phoneController.text == null || _dateOfBirth == null || _passwordController.text == null) {
                              AuthController.showSnackBar(title: "Sign in failed", message: "Please fill all fields", bgColor: Colors.red, txtColor: Colors.white);
                            } else {
                              String _formatedPhone = checkPhoneNumber(_phoneController.text);
                              print(_formatedPhone);
                              if (_formatedPhone == "error") {
                                AuthController.showSnackBar(
                                    title: "Incorrect phone number",
                                    message: "Please fill your phone number correctly",
                                    txtColor: Colors.white,
                                    bgColor: Colors.red,
                                    durationSecond: 2,
                                    position: SnackPosition.TOP);
                              } else {
                                _authController.signInWithPhone(
                                  phoneNumber: _formatedPhone,
                                  name: _nameController.text,
                                  profilePickedFile: _pickedFile,
                                  dob: _dateOfBirth,
                                  password: _passwordController.text,
                                );
                              }
                            }
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
