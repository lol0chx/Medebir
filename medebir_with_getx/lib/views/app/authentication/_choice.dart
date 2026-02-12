import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:medebir_with_getx/controllers/auth_controller.dart';
import 'package:medebir_with_getx/views/app/authentication/signin_phone.dart';
import '../authentication/signup_email.dart';
import '../authentication/signin_email.dart';

class LoginChoiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  height: deviceHeight * 0.5,
                  child: Lottie.asset(
                    'assets/72170-books.json',
                    frameRate: FrameRate(60.0),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.01),
                      Text(
                        'It\'s easier to sign up now',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(height: deviceHeight * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: MaterialButton(
                          elevation: 15,
                          onPressed: () {
                            // Google sign in
                            authController.signInWithGoogle();
                          },
                          height: 50.0,
                          minWidth: double.infinity,
                          color: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                              ),
                              SizedBox(width: deviceWidth * 0.13),
                              Text(
                                'Continue with Google',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.02),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 45.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50.0),
                          onTap: () {
                            Get.to(() => SignUpScreen(), transition: Transition.cupertino);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.mail, color: Colors.redAccent),
                                SizedBox(width: deviceWidth * 0.1),
                                Text(
                                  'Sign up with Email',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.01),
                      // implement the phone and email login and make it saved or remembered
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 45.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50.0),
                          onTap: () {
                            Get.to(() => SignInPhoneScreen(), transition: Transition.cupertino);
                            // Get.to(() => PhoneCheckScreen(), transition: Transition.cupertino);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.phone,
                                  color: Colors.green,
                                ),
                                SizedBox(width: deviceWidth * 0.1),
                                Text(
                                  'Sign up with Phone',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have account?',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(() => SignInScreen(), transition: Transition.cupertino);
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16.0,
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
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
