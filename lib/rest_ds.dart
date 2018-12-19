import 'dart:async';

import 'package:simple_war_client/models/user.dart';
import 'package:simple_war_client/network_util.dart';

class RestDatasource {

  NetworkUtil _netUtil = new NetworkUtil();

  static final BASE_URL = "http://localhost:8080";
  static final LOGIN_PATH = "/user/login";
  static final REGISTER_PATH = "/user/register";

  Future<User> login(String username, String password) {
    print("Logging in...");
    String loginUrl = BASE_URL + LOGIN_PATH;

    Map body;
    if (username.contains("@")) {
      body = {
        "email" : username,
        "password" : password
      };
    } else {
      body = {
        "username" : username,
        "password" : password
      };
    }

    return _netUtil
        .post(loginUrl, body)
        .then((dynamic res) {
          return new User.map(res);
        });
  }

  Future<User> register(String username, String password, String email) {
    print("Registering...");
    String loginUrl = BASE_URL + REGISTER_PATH;

    Map body = {
      "username" : username,
      "password" : password,
      "email" : email
    };

    return _netUtil
        .post(loginUrl, body)
        .then((dynamic res) {
      return new User.map(res);
    });
  }
}