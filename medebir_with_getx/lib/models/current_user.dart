import 'dart:convert';

import 'package:flutter/cupertino.dart';

//
class CurrentUser {
  String userId;
  String name;
  String email;
  DateTime dateOfBirth;
  String profileImgUrl;
  String password;

  CurrentUser({@required this.userId, @required this.name, @required this.email, @required this.dateOfBirth, @required this.profileImgUrl, this.password = ""});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'dateOfBirth': dateOfBirth.millisecondsSinceEpoch,
      'profileImgUrl': profileImgUrl,
      'password': password,
    };
  }

  factory CurrentUser.fromMap(Map<String, dynamic> map) {
    return CurrentUser(
      userId: map['userId'],
      name: map['name'],
      email: map['email'],
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth']),
      profileImgUrl: map['profileImgUrl'],
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CurrentUser.fromJson(String source) => CurrentUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CurrentUser(userId: $userId, name: $name, email: $email, dateOfBirth: $dateOfBirth, profileImgUrl: $profileImgUrl, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CurrentUser &&
        other.userId == userId &&
        other.name == name &&
        other.email == email &&
        other.dateOfBirth == dateOfBirth &&
        other.profileImgUrl == profileImgUrl &&
        other.password == password;
  }

  @override
  int get hashCode {
    return userId.hashCode ^ name.hashCode ^ email.hashCode ^ dateOfBirth.hashCode ^ profileImgUrl.hashCode ^ password.hashCode;
  }
}
