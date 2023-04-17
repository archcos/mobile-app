import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';
import 'Dio.dart';

class Auth extends ChangeNotifier {
  bool _isLoggedIn = false;
  late User _user;
  late String _token;

  bool get authenticated => _isLoggedIn;
  User get user => _user;

  final storage = new FlutterSecureStorage();

  void login({required Map creds}) async {
    print(creds);

    try {
      Dio.Response response = await dio().post('/sanctum/login', data: creds);
      print(response.data.toString());

      String token = response.data.toString();
      this.tryToken(token: token);
    } catch (e) {
      print(e);
    }
  }


  void register({required Map creds}) async {
    print(creds);

    try {
      Dio.Response response = await dio().post('/sanctum/register', data: creds);
      print(response.data.toString());

      String token = response.data.toString();
      this.tryToken(token: token);
    } catch (e) {
      if (e is Dio.DioError) {
        if (e.response?.statusCode == 422) {
          print(e.response?.data);
        } else {
          print(e);
        }
      } else {
        print(e);
      }
    }
  }

  void tryToken({required String token}) async {
    if (token.isEmpty) {
      return;
    } else {
      try {
        Dio.Response response = await dio().get('/user',
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        this._isLoggedIn = true;
        this._user = User.fromJson(response.data);
        this._token = token;
        this.storeToken(token: token);
        notifyListeners();
        print(_user);
      } catch (e) {
        print(e);
      }
    }
  }

  void storeToken({required String token}) async {
    this.storage.write(key: 'token', value: token);
  }

  void logout() async {
    try {
      Dio.Response response = await dio().get('/user/revoke',
          options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));

      await cleanUp();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

   cleanUp() async {
    this._user = User();
    this._isLoggedIn = false;
    this._token = '';
    await storage.delete(key: 'token');
  }
}
