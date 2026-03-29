import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:zvychka/api/zvychka/user.dart';
import 'package:zvychka/helpers/log.dart';
import 'package:zvychka/helpers/preload_data.dart';
import 'package:zvychka/models/user.dart';

import '../helpers/cache.dart';

class Auth {
  static final Auth _auth = Auth._internal();
  static User _user = User();
  static final Cache _cache = Cache(tag: 'auth');
  static const String _tokenKey = 'auth_token';

  factory Auth() {
    return _auth;
  }

  static Future<void> updateFcmToken() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.deleteToken().then((value) => FirebaseMessaging.instance.getToken());
      ApiUser.update(fcmToken: fcmToken);
    } catch (e) {
      Log.e("Error update fcmToken: $e");
    }
  }

  static Future<void> initUser() async {
    // await ApiPayment.check();//init
    _user = await ApiUser.get();
    _user = await ApiUser.update(timeZone: DateTime.now().timeZoneName);

    updateFcmToken();

    PreloadData.load(resetCache: false);
  }

  static void setUser(User user) {
    _user = user;
  }

  static User user() {
    return _user;
  }

  static Future<String> getToken() async {

    //return '339|Ptxl8bwa8e78fEH5Pe25llj0lreaEKlUCxx3MSH4e562d378';
    final token = await _cache.get(key: _tokenKey);
    return token?.toString() ?? "";
  }

  static Future<void> remember(String token) async {
    await _cache.add(key: _tokenKey, value: token);
  }

  static Future<void> forget() async {
    Log.log('⛔⛔⛔ FORGET!!!!');
    await _cache.forget(key: _tokenKey);
    _user = User();
  }

  Auth._internal();
}
