import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;


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
      final response = await http.post(Uri.parse('https://example.com/sanctum/login'),
          body: creds,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'});

      final contentType = MediaType.parse(response.headers['content-type'] ?? '');
      if (contentType.type == 'application' && contentType.subtype == 'json') {
        final token = response.body;
        this.tryToken(token: token);
      } else {
        print('Unexpected response content type: ${contentType.toString()}');
      }
    } catch (e) {
      print(e);
    }
  }


  Future register({required Map creds}) async {
    print(creds);

    try {
      final response = await http.post(Uri.parse('https://example.com/sanctum/register'),
          body: creds,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'});

      final contentType = MediaType.parse(response.headers['content-type'] ?? '');
      if (contentType.type == 'application' && contentType.subtype == 'json') {
        final token = response.body;
        this.tryToken(token: token);
      } else {
        print('Unexpected response content type: ${contentType.toString()}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        print(e.message);
      } else if (e is http.Response) {
        if (e.statusCode == 422) {
          print(e.body);
        } else {
          print('HTTP error ${e.statusCode}');
        }
      } else {
        print(e.toString());
      }
    }
  }

  void tryToken({required String token}) async {
    if (token.isEmpty) {
      return;
    } else {
      try {
        http.Response response = await http.get(Uri.parse('https://example.com/user'),
            headers: {'Authorization': 'Bearer $token'});
        if (response.statusCode == 200) {
          this._isLoggedIn = true;
          this._user = User.fromJson(json.decode(response.body));
          this._token = token;
          this.storeToken(token: token);
          notifyListeners();
          print(_user);
        } else {
          print('Error: ${response.statusCode}');
        }
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
      http.Response response = await http.post(Uri.parse('https://example.com/sanctum/revoke'));
      if (response.statusCode == 200) {
        String token = response.body;
        this.tryToken(token: token);
      } else {
        print('Error: ${response.statusCode}');
      }
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
