import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:medebir_with_getx/controllers/auth_controller.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

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
                    'Hello,',
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
                    'Sign up',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 32.0),
                  ),
                ),
                SizedBox(height: devHeight * 0.01),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => setPickedFile(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                              image: _proPicImgFile != null ? DecorationImage(image: FileImage(_proPicImgFile), fit: BoxFit.fill) : null,
                            ),
                            height: 100,
                            width: 100,
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
                        SizedBox(height: devHeight * 0.03),

                        TextFormField(
                          keyboardType: TextInputType.name,
                          style: TextStyle(),
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
                        //DateOfBirth implementation
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
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                            labelText: "Email",
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
                        TextFormField(
                          obscureText: true,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                            labelText: "Password",
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
                        TextFormField(
                          obscureText: true,
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                            labelText: "Confirm password",
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
                        //

                        //

                        SizedBox(height: devHeight * 0.04),
                        MaterialButton(
                          onPressed: () {
                            // implement the sign in button
                            if (_pickedFile == null ||
                                _nameController.text == null ||
                                _passwordController.text == null ||
                                _dateOfBirth == null ||
                                _emailController.text == null ||
                                _confirmPasswordController.text == null) {
                              AuthController.showSnackBar(title: "Sign up failed", message: "Please fill all inputs", bgColor: Colors.red, txtColor: Colors.white);
                            } else {
                              print('selectedImage: ${_pickedFile.path}');
                              if (_passwordController.text == _confirmPasswordController.text) {
                                authController.createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  name: _nameController.text,
                                  dob: _dateOfBirth,
                                  profilePickedFile: _pickedFile,
                                );
                              } else {
                                Get.snackbar("Sign up failed", "Password Doesn't match.");
                              }
                            }
                          },
                          height: 50.0,
                          minWidth: 200.0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                          color: Theme.of(context).primaryColor,
                          child: Text('Sign Up', style: TextStyle(color: Colors.white, fontSize: 16.0)),
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
