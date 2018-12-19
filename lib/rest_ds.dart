import 'dart:async';

import 'package:simple_war_client/models/user.dart';
import 'package:simple_war_client/network_util.dart';

class RestDatasource {

  NetworkUtil _netUtil = new NetworkUtil();

  static final BASE_URL = "http://localhost:8080";
  static final LOGIN_PATH = "/login";
  static final REGISTER_PATH = "/register";

  Future<User> login(String username, String password) {

    String loginUrl = BASE_URL + LOGIN_PATH + "/$username/$password";
    print("Calling url: " + loginUrl);

    return _netUtil
        .get(loginUrl)
        .then((dynamic res) {
          print(res.toString());
          if (res["player"]) {
            return new User.map(res["player"]);
          } else {
            throw new Exception("Error logging in...");
          }
        });
  }

  Future<User> register(String username, String password, String email) {

    String loginUrl = BASE_URL + REGISTER_PATH + "/$username/$password/$email";
    print("Calling url: " + loginUrl);

    return _netUtil
        .get(loginUrl)
        .then((dynamic res) {
      print(res.toString());
      if (res["player"]) {
        return new User.map(res["player"]);
      } else {
        throw new Exception("Error registering...");
      }
    });
  }
}