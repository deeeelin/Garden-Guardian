import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/log_in_method.dart';

class appUser {
  String id;
  final String? userName;
  final String? email;
  final String? avatarUrl;
  late final List<LogInMethod> logInMethods;
  String? pushMessagingToken;
  int cnt_signin;
  int cnt_watering;
  //int cnt_fertilizing;
  //int cnt_pruning;
  int cnt_plantNum;
  int cnt_plantType;
  int cnt_drink;

  appUser({
    required this.id,
    this.userName,
    this.email,
    this.avatarUrl,
    required this.cnt_signin,
    required this.cnt_watering,
    //required this.cnt_fertilizing,
    //required this.cnt_pruning,
    required this.cnt_plantNum,
    required this.cnt_plantType,
    required this.cnt_drink,
    logInMethods,
    this.pushMessagingToken,
  }) : logInMethods = logInMethods ?? [];

  factory appUser.fromMap(Map<String, dynamic> map, String id) {
    return appUser(
      id: map['id'],
      userName: map['userName'],
      email: map['email'],
      avatarUrl: map['avatarUrl'],
      cnt_signin: map['cnt_signin'],
      cnt_watering: map['cnt_watering'],
      //cnt_fertilizing: map['cnt_fertilizing'],
      //cnt_pruning: map['cnt_pruning'],
      cnt_plantNum: map['cnt_plantNum'],
      cnt_plantType: map['cnt_plantType'],
      cnt_drink: map['cnt_drink'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'avatarUrl': avatarUrl,
      'logInMethods':
          logInMethods?.map((logInMethod) => logInMethod.name).toList(),
      'pushMessagingToken': pushMessagingToken,
      'cnt_signin': cnt_signin,
      'cnt_watering': cnt_watering,
      //'cnt_fertilizing': cnt_fertilizing,
      //'cnt_pruning': cnt_pruning,
      'cnt_plantNum': cnt_plantNum,
      'cnt_plantType': cnt_plantType,
      'cnt_drink': cnt_drink,
    };
  }
}
