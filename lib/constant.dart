import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

showSnackBar(title) {
  Fluttertoast.showToast(
      msg: "$title",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
// one signal AppId
const mOneSignalAppId = 'f869b7e5-ca30-42ea-8640-88a0f76c324c';
const mOneSignalRestKey = 'NTc1Yjk5NjMtNjAyMC00ZmNmLWFmZTQtN2M4NjFjZGIyYTMy';

Future<void> sendPushNotifications({String? title, String? content, List<String?>? listUser, String? orderId}) async {
  Map dataMap = {};

  if (orderId != null) {
    dataMap.putIfAbsent('orderId', () => orderId);
  }
  print('player idsss ${listUser}');
  Map req = {
    'headings': {'en': title},
    'contents': {'en': content},
    'data': dataMap,
    'app_id': mOneSignalAppId,
    "include_player_ids": listUser,
  };

  var header = {
    HttpHeaders.authorizationHeader: 'Basic $mOneSignalRestKey',
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    // 'Content-Type': 'application/json; charset=utf-8',
  };

  Response res = await post(
    Uri.parse('https://onesignal.com/api/v1/notifications'),
    body: jsonEncode(req),
    headers: header,
  );

  log(res.statusCode.toString());
  log(res.body);

  if (res.statusCode=='200') {
    return;
  } else {
    // print('notification error${errorSomethingWentWrong}');
    // throw errorSomethingWentWrong;
  }
}

const PLAYER_ID = 'PLAYER_ID';
Future<void> saveOneSignalPlayerId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  await OneSignal.shared.getDeviceState().then((value) async {
    if (value!.userId!.isNotEmpty) {
      return pref.setString(PLAYER_ID, value.userId!);
    }
  });

  String getPlayerID = pref.getString(PLAYER_ID)??"";
  print('get pref player id ${getPlayerID}');

  FirebaseFirestore.instance
      .collection('users')
      .doc('bTJLub7ageTpjCjvDIiVtygylj32')
      .update({'oneSignalPlayerId': getPlayerID})
      .then((value) => print("Field updated successfully!"))
      .catchError((error) => print("Failed to update field: $error"));
}

setValue(playerID,id)async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.setString(playerID, id);
}
getStringAsync(playerID)async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  var getPlayerID = pref.getString(playerID);
  return getPlayerID ;
}