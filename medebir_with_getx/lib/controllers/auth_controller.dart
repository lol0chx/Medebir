import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:medebir_with_getx/views/app/authentication/_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medebir_with_getx/models/current_user.dart';
import 'package:medebir_with_getx/views/app/authentication/phone_auth_screen.dart';
import 'package:medebir_with_getx/views/app/home/loading.dart';
import 'package:medebir_with_getx/views/app/home/home.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User> _firebaseUser = Rxn<User>();

  String get user => _firebaseUser.value?.email;

  GoogleSignIn _googleSignIn = GoogleSignIn();
  //current user by our own object
  // CurrentUser _currentUser = CurrentUser();
  Rxn<CurrentUser> _currentUser = Rxn<CurrentUser>();
  CurrentUser get currentUser => _currentUser.value;

  @override
  void onInit() async {
    _firebaseUser.bindStream(_auth.authStateChanges());
    // print("inside onInit userId: ${_auth.currentUser.uid}");
    if (_auth.currentUser != null) {
      print("user Id On startup: " + _auth.currentUser.uid);
      await _fetchUserInfoFromFireStore(_auth.currentUser.uid);
    }
    super.onInit();
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

  //converts the user from firebase to an object of our current user model
  CurrentUser _userFromFirebase({String userId, String name, String email, DateTime dateOfBirth, String profileImgUrl, String password}) {
    if (userId != null) {
      CurrentUser _newCurrentUser = CurrentUser(userId: userId, name: name, email: email, dateOfBirth: dateOfBirth, profileImgUrl: profileImgUrl, password: password);
      return _newCurrentUser;
    } else {
      return null;
    }
  }

  //implement the storing
  void _storeUserInfoToFireStore(CurrentUser currentUser) async {
    bool userExists = false;
    List<CurrentUser> usersList = [];
    CollectionReference usersReference = FirebaseFirestore.instance.collection("Users");
    await usersReference.get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        usersList.add(CurrentUser.fromMap(element.data()));
      });
      print('found: ${usersList.length} users in DB');
    });
    usersList.forEach((user) {
      if (user.userId == currentUser.userId) {
        userExists = true;
        print('user already exists');
        print(" Name: ${user.name}\n Email: ${user.email} \n DOB: ${user.dateOfBirth} \n ProfileImgUrl: ${user.profileImgUrl}");
      }
    });
    if (userExists != true) {
      usersReference.add(_currentUser.value.toMap());
      print('user added to DB');
    }
  }

  //implement the fetching
  Future _fetchUserInfoFromFireStore(String userId) async {
    if (userId != null) {
      print("inside fetch method userId: $userId");
      List<CurrentUser> usersList = [];
      CollectionReference usersReference = FirebaseFirestore.instance.collection("Users");
      await usersReference.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          usersList.add(CurrentUser.fromMap(element.data()));
        });
      });
      print("${usersList.length} users in DB");
      usersList.forEach((_user) {
        if (_user.userId == userId) {
          print(
              "current usersId Found in DB:${_user.userId} with \n userName: ${_user.name} \n Email: ${_user.email} \n DOB: ${_user.dateOfBirth} \n ProfileImgUrl: ${_user.profileImgUrl} \n password: ${_user.password}");
          _currentUser.value = _user;
        }
      });
    }
  }

  //create user with email and password
  Future createUserWithEmailAndPassword(
      {@required String email, @required String password, @required String name, @required DateTime dob, @required PickedFile profilePickedFile}) async {
    Get.to(() => Loading(), transition: Transition.fadeIn);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      String profileImgUrl = await uploadProfileImageToFirebase(profilePickedFile);
      print("userId: ${userCredential.user.uid}");
      _currentUser.value = _userFromFirebase(userId: userCredential.user.uid, name: name, email: email, dateOfBirth: dob, profileImgUrl: profileImgUrl);
      update();
      _storeUserInfoToFireStore(_currentUser.value);
      Get.offAll(() => HomeScreen());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        showSnackBar(bgColor: Colors.red, message: "The password provided is too weak", title: "Sign up failed", txtColor: Colors.white);
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        showSnackBar(bgColor: Colors.red, message: "The account already exists for that email.", title: "Sign up failed", txtColor: Colors.white);
      }
    } catch (e) {
      showSnackBar(bgColor: Colors.red, message: "${e.message}", title: "Sign up failed", txtColor: Colors.white);
    }
    print(_currentUser.value);
  }

  Future<String> uploadProfileImageToFirebase(PickedFile profilePickedFile) async {
    File _image;
    CloudinaryResponse cloudinaryResponse;
    if (profilePickedFile != null) {
      _image = File(profilePickedFile.path);
    } else {
      print('No image selected.');
    }
    String _cloudName = "df8icafxq";
    String _uploadPreset = "qlylnks5";
    final cloudinary = CloudinaryPublic(_cloudName, _uploadPreset, cache: false);
    try {
      //upload to cloudinary
      cloudinaryResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(_image.path, resourceType: CloudinaryResourceType.Image),
      );
      print(cloudinaryResponse.secureUrl);
    } catch (e) {
      showSnackBar(bgColor: Colors.red, message: "${e.message}", title: "uploading image failed", txtColor: Colors.white);
    }
    return cloudinaryResponse.secureUrl;
  }

  //sign in user with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      print("userId: ${userCredential.user.uid}");
      _fetchUserInfoFromFireStore(userCredential.user.uid);
      Get.offAll(() => HomeScreen());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        showSnackBar(bgColor: Colors.red, message: "No user found for that email.", title: "Sign in failed", txtColor: Colors.white);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        showSnackBar(bgColor: Colors.red, message: "Wrong password provided for that user.", title: "Sign in failed", txtColor: Colors.white);
      }
    } catch (e) {
      showSnackBar(bgColor: Colors.red, message: "${e.message}", title: "Sign in failed", txtColor: Colors.white);
    }
  }

  // implement a sign in with google method
  void signInWithGoogle() async {
    GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: _googleAuth.idToken,
      accessToken: _googleAuth.accessToken,
    );

    Get.to(() => Loading(), transition: Transition.fadeIn);
    try {
      await _auth.signInWithCredential(credential);
      print("user signed in.");
      print("id inside google method: " + _auth.currentUser.uid);
    } catch (e) {
      showSnackBar(bgColor: Colors.red, message: "$e", title: "Sign in failed", txtColor: Colors.white);
    }
    _currentUser.value =
        _userFromFirebase(userId: _auth.currentUser.uid, name: _googleUser.displayName, email: _googleUser.email, dateOfBirth: DateTime.now(), profileImgUrl: _googleUser.photoUrl);
    _storeUserInfoToFireStore(_currentUser.value);
    print('going to home screen');

    Get.offAll(() => HomeScreen());
  }

  //sign out google
  void signOutGoogle() async {
    await _googleSignIn.signOut();
  }

  Future<bool> checkIfUserIsSignedUpWithPhone(String phoneNumber) async {
    List<CurrentUser> usersList = [];
    CollectionReference usersReference = FirebaseFirestore.instance.collection("Users");
    await usersReference.get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        usersList.add(CurrentUser.fromMap(element.data()));
      });
      print('found: ${usersList.length} users in DB');
    });
    final alreadySignedUp = usersList.any((user) {
      if (phoneNumber == user.email) {
        // userExists = true;
        print('user already exists');
        print(" Name: ${user.name}\n Email: ${user.email} \n DOB: ${user.dateOfBirth} \n ProfileImgUrl: ${user.profileImgUrl}");
        _currentUser.value = _userFromFirebase(userId: user.userId, name: user.name, email: user.email, dateOfBirth: user.dateOfBirth, profileImgUrl: user.profileImgUrl);
        return true;
      }
      return false;
    });
    return alreadySignedUp;
  }

  Future signInWithPhoneNumberAndPassword(String phoneNumber, String password) async {
    List<CurrentUser> usersList = [];
    CollectionReference usersReference = FirebaseFirestore.instance.collection("Users");
    await usersReference.get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        usersList.add(CurrentUser.fromMap(element.data()));
      });
      print('found: ${usersList.length} users in DB');
    });
    //
    CurrentUser _user;
    usersList.forEach((user) {
      if (phoneNumber == user.email) {
        _user = CurrentUser(userId: user.userId, name: user.name, email: user.email, dateOfBirth: user.dateOfBirth, profileImgUrl: user.profileImgUrl, password: user.password);
      }
    });
    if (password == _user.password) {
      _currentUser.value = _userFromFirebase(
          userId: _user.userId, name: _user.name, email: _user.email, dateOfBirth: _user.dateOfBirth, profileImgUrl: _user.profileImgUrl, password: _user.password);
      Get.offAll(() => HomeScreen());
    } else {
      showSnackBar(bgColor: Colors.red, message: "Incorrect password", title: "Sign in failed", txtColor: Colors.white);
    }
  }

  // implement a sign in with phone method
  Future signInWithPhone({String phoneNumber, String name, @required PickedFile profilePickedFile, @required DateTime dob, @required String password}) async {
    TextEditingController _otpCodeController = TextEditingController();
    Get.to(() => Loading());

    final alreadySignedUp = await checkIfUserIsSignedUpWithPhone(phoneNumber);
    if (alreadySignedUp) {
      print("breaking out of the function");
      Get.to(() => PhoneAuth(phoneNumber: phoneNumber));
      return;
    }
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 0),
        verificationCompleted: (phoneAuthCredential) async {
          try {
            //here
            await _auth.signInWithCredential(phoneAuthCredential);
          } catch (e) {
            showSnackBar(bgColor: Colors.red, message: "${e.message}", title: "Sign in failed", txtColor: Colors.white);
          }
          String _profileImgUrl = await uploadProfileImageToFirebase(profilePickedFile);
          _currentUser.value =
              _userFromFirebase(userId: _auth.currentUser.uid, name: name, email: phoneNumber, dateOfBirth: dob, profileImgUrl: _profileImgUrl, password: password);
          print("user: ${_currentUser.value} has been stored to db");
          //:check if user is already signed in with this phone number
          _storeUserInfoToFireStore(_currentUser.value);
          print('going to home screen');
          Get.offAll(() => HomeScreen());
        },
        verificationFailed: (verificationFailed) async {
          return "error";
        },
        codeSent: (verificationId, resendingToken) async {
          Get.defaultDialog(
            barrierDismissible: false,
            title: "Enter OTP",
            titleStyle: TextStyle(),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _otpCodeController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
              ],
            ),
            actions: [
              MaterialButton(
                minWidth: double.infinity,
                height: 40.0,
                onPressed: () async {
                  Get.to(() => Loading());
                  //
                  AuthCredential _credential = PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: _otpCodeController.text.trim(),
                  );
                  try {
                    //here
                    await _auth.signInWithCredential(_credential);
                  } catch (e) {
                    showSnackBar(bgColor: Colors.red, message: "${e.message}", title: "Sign in failed", txtColor: Colors.white);
                  }
                  String _profileImgUrl = await uploadProfileImageToFirebase(profilePickedFile);
                  _currentUser.value =
                      _userFromFirebase(userId: _auth.currentUser.uid, name: name, email: phoneNumber, dateOfBirth: dob, profileImgUrl: _profileImgUrl, password: password);
                  print("user: ${_currentUser.value} has been stored to db");
                  _storeUserInfoToFireStore(_currentUser.value);
                  print('going to home screen');
                  Get.offAll(() => HomeScreen());
                },
                color: Colors.black,
                child: Text('Verify', style: TextStyle(color: Colors.white)),
              )
            ],
          );
        },
        codeAutoRetrievalTimeout: (verificationId) async {
          verificationId = verificationId;
          print(verificationId);
          print('timeout');
          // Get.snackbar("Timeout", "please try again later.");
        },
      );
    } catch (e) {
      showSnackBar(bgColor: Colors.red, message: "${e.message}", title: "Sign in failed", txtColor: Colors.white);
    }
  }

  //reset password using email
  void resetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email).then((value) {
      Get.defaultDialog(
        title: "Email sent",
        middleText: "Follow instruction on the email sent to you to reset your password.",
        actions: [
          MaterialButton(
            minWidth: double.infinity,
            height: 40.0,
            color: Colors.teal,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            onPressed: () {
              Get.offAll(() => LoginChoiceScreen());
            },
            child: Text('Ok', style: TextStyle(color: Colors.white)),
          ),
        ],
      ).catchError(
        (error) => showSnackBar(bgColor: Colors.red, message: "${error.message}", title: "Sign in failed", txtColor: Colors.white),
      );
    });
  }

  //delete account
  void deleteAccount(String email, String password) async {
    User user = _auth.currentUser;
    AuthCredential _credential = EmailAuthProvider.credential(email: email, password: password);
    await user.reauthenticateWithCredential(_credential).then((value) {
      value.user.delete();
    }).then((value) {
      Get.offAll(() => LoginChoiceScreen());
      Get.snackbar("Account Deleted", "Account has been removed.", snackPosition: SnackPosition.TOP);
    }).catchError(
      (error) => showSnackBar(bgColor: Colors.red, message: "${error.message}", title: "Sign in failed", txtColor: Colors.white),
    );
  }

  //sign out user
  void signOut() async {
    if (!_googleSignIn.isBlank) {
      signOutGoogle();
      print("google signed out...");
    }
    await _auth.signOut().then((value) => Get.offAll(() => LoginChoiceScreen(), transition: Transition.cupertino)).catchError(
          (error) => showSnackBar(bgColor: Colors.red, message: "${error.message}", title: "Sign in failed", txtColor: Colors.white),
        );
  }
}
