import 'dart:async';

import 'package:simple_war_client/models/game.dart';
import 'package:simple_war_client/models/user.dart';
import 'package:simple_war_client/service/network_util.dart';

class RestDatasource {

  NetworkUtil _netUtil = new NetworkUtil();

  static final BASE_URL = "http://localhost:8080";
  static final LOGIN_PATH = "/user/login";
  static final REGISTER_PATH = "/user/register";
  static final GAME_PATH = "/game";
  static final START_GAME_PATH = "/game/start";
  static final END_TURN_PATH = "/game/endTurn";
  static final DISCARD_HAND_PATH = "/game/discardHand";

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
          return new User.fromJSON(res);
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
          return new User.fromJSON(res);
        });
  }

  Future<List<Game>> getGamesForUser(String username) {
    print("Getting games...");
    String gamesUrl = BASE_URL + GAME_PATH + "/$username";
    return _netUtil
        .get(gamesUrl)
        .then((dynamic res) {
          return (res as List).map((i) => Game.fromJSON(i)).toList();
    });
  }

  Future<Game> startGame(String username) {
    print("Starting game...");
    String url = BASE_URL + START_GAME_PATH + "/$username";

    return _netUtil
        .get(url)
        .then((dynamic res) {
      return new Game.fromJSON(res);
    });
  }

  Future<Game> getGameByIdAndUsername(String gameId, String username) {
    print("Getting game by id and username");
    String url = BASE_URL + GAME_PATH + "/$gameId" + "/$username";

    return _netUtil
        .get(url)
        .then((dynamic res) {
      return new Game.fromJSON(res);
    });
  }

  Future<Game> endTurnByIdAndUsername(String gameId, String username, bool discard) {
    print("End turn by id and username");
    String url = BASE_URL + END_TURN_PATH + "/$gameId/$username?discard=$discard";

    return _netUtil
        .get(url)
        .then((dynamic res) {
      return new Game.fromJSON(res);
    });
  }

}