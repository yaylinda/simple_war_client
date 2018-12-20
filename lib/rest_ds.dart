import 'dart:async';

import 'package:simple_war_client/models/game.dart';
import 'package:simple_war_client/models/user.dart';
import 'package:simple_war_client/network_util.dart';

class RestDatasource {

  NetworkUtil _netUtil = new NetworkUtil();

  static final BASE_URL = "http://localhost:8080";
  static final LOGIN_PATH = "/user/login";
  static final REGISTER_PATH = "/user/register";
  static final GAME_PATH = "/game";
  static final START_GAME_PATH = "/game/start";

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

  Future<List<Game>> getGamesForUser(String username) {
    print("Getting games...");
    String gamesUrl = BASE_URL + GAME_PATH + "/$username";
    return _netUtil
        .get(gamesUrl)
        .then((dynamic res) {
          return (res as List).map((i) => Game.map(i)).toList();
    });
  }

  Future<Game> startGame(String username) {
    print("Starting game...");
    String url = BASE_URL + START_GAME_PATH + "/$username";

    return _netUtil
        .get(url)
        .then((dynamic res) {
      return new Game.map(res);
    });
  }
}